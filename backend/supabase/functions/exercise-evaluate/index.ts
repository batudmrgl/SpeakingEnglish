import { corsHeaders, jsonResponse } from "../_shared/cors.ts";
import { createStructuredResponse } from "../_shared/openai.ts";
import { exerciseJsonSchema, validateExerciseEvaluation } from "../_shared/learning-schema.ts";

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
      return jsonResponse(mockEvaluation(body.prompt?.expectedAnswer ?? ""));
    }

    const raw = await createStructuredResponse(
      buildExerciseInstructions(),
      body,
      exerciseJsonSchema(),
    );
    return jsonResponse(validateExerciseEvaluation(raw));
  } catch (error) {
    return jsonResponse(
      { error: error instanceof Error ? error.message : "Unknown error" },
      500,
    );
  }
});

function buildExerciseInstructions(): string {
  return [
    "Evaluate the user's English learning exercise answer.",
    "For English-to-Turkish tasks, grade meaning rather than literal translation.",
    "For Turkish-to-English tasks, grade grammar, word choice, word order, and naturalness.",
    "Explain mistakes briefly in Turkish.",
    "Return only JSON that matches the provided schema.",
  ].join("\n");
}

function mockEvaluation(expectedAnswer: string) {
  return {
    is_correct: true,
    score: 88,
    feedback_tr: "Cevabin hedef anlama yakin.",
    corrected_answer: expectedAnswer,
    explanation_tr: "Bu prototip mock backend ile calisiyor. Gercek model baglandiginda daha ayrintili kontrol yapilacak.",
    next_prompt_hint: "Yeni soruya gecebilirsin.",
  };
}

