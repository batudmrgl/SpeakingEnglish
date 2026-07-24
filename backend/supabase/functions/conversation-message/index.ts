import { corsHeaders, jsonResponse } from "../_shared/cors.ts";
import { createStructuredResponse } from "../_shared/openai.ts";
import { teacherJsonSchema, validateTeacherResponse } from "../_shared/learning-schema.ts";

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  if (req.method !== "POST") {
    return jsonResponse({ error: "Method not allowed" }, 405);
  }

  try {
    const body = await req.json();

    if (!Deno.env.get("OPENAI_API_KEY")) {
      return jsonResponse(mockTeacherResponse(body.userText ?? ""));
    }

    const system = buildTeacherInstructions(body.profile);
    const raw = await createStructuredResponse(system, body, teacherJsonSchema());
    return jsonResponse(validateTeacherResponse(raw));
  } catch (error) {
    return jsonResponse(
      { error: error instanceof Error ? error.message : "Unknown error" },
      500,
    );
  }
});

function buildTeacherInstructions(profile: Record<string, unknown> | undefined): string {
  return [
    "You are a patient English speaking teacher for Turkish learners.",
    "Keep the main conversation in English.",
    "Use short Turkish explanations only for corrections.",
    "Do not over-correct; preserve conversation flow.",
    `User profile: ${JSON.stringify(profile ?? {})}`,
    "Return only JSON that matches the provided schema.",
  ].join("\n");
}

function mockTeacherResponse(userText: string) {
  const lower = userText.toLowerCase();
  if (lower.includes("yesterday i go")) {
    return {
      assistant_reply: "Nice. You went there yesterday. What did you do after that?",
      should_correct: true,
      corrections: [
        {
          original: userText,
          highlighted_part: "Yesterday I go",
          corrected: userText.replace(/yesterday i go/i, "Yesterday I went"),
          error_type: "past_tense",
          explanation_tr: "Gecmiste olan bir olaydan bahsettigin icin 'go' yerine 'went' kullanmalisin.",
          natural_alternative: "I went there yesterday.",
          pronunciation_tip: null,
          severity: "medium",
        },
      ],
      new_vocabulary: [
        {
          word: "after that",
          meaning_tr: "ondan sonra",
          example: "What did you do after that?",
        },
      ],
      follow_up_question: "What did you do after that?",
    };
  }

  return {
    assistant_reply: "I understand. Can you tell me one more detail?",
    should_correct: false,
    corrections: [],
    new_vocabulary: [],
    follow_up_question: "Can you tell me one more detail?",
  };
}

