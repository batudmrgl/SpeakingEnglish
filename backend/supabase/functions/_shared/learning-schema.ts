export type Correction = {
  id?: string;
  original: string;
  highlighted_part: string;
  corrected: string;
  error_type: string;
  explanation_tr: string;
  natural_alternative?: string | null;
  pronunciation_tip?: string | null;
  severity: "low" | "medium" | "high";
};

export type TeacherResponse = {
  assistant_reply: string;
  should_correct: boolean;
  corrections: Correction[];
  new_vocabulary: Array<{
    id?: string;
    word: string;
    meaning_tr: string;
    example: string;
  }>;
  follow_up_question?: string | null;
};

export type ExerciseEvaluation = {
  is_correct: boolean;
  score: number;
  feedback_tr: string;
  corrected_answer: string;
  explanation_tr: string;
  next_prompt_hint?: string | null;
};

export function validateTeacherResponse(value: unknown): TeacherResponse {
  const data = value as Partial<TeacherResponse>;
  if (
    typeof data?.assistant_reply !== "string" ||
    typeof data?.should_correct !== "boolean" ||
    !Array.isArray(data?.corrections) ||
    !Array.isArray(data?.new_vocabulary)
  ) {
    throw new Error("Invalid teacher response schema");
  }
  return {
    assistant_reply: data.assistant_reply,
    should_correct: data.should_correct,
    corrections: data.corrections,
    new_vocabulary: data.new_vocabulary,
    follow_up_question: data.follow_up_question ?? null,
  };
}

export function validateExerciseEvaluation(value: unknown): ExerciseEvaluation {
  const data = value as Partial<ExerciseEvaluation>;
  if (
    typeof data?.is_correct !== "boolean" ||
    typeof data?.score !== "number" ||
    typeof data?.feedback_tr !== "string" ||
    typeof data?.corrected_answer !== "string" ||
    typeof data?.explanation_tr !== "string"
  ) {
    throw new Error("Invalid exercise evaluation schema");
  }
  return {
    is_correct: data.is_correct,
    score: Math.max(0, Math.min(100, Math.round(data.score))),
    feedback_tr: data.feedback_tr,
    corrected_answer: data.corrected_answer,
    explanation_tr: data.explanation_tr,
    next_prompt_hint: data.next_prompt_hint ?? null,
  };
}

export function teacherJsonSchema() {
  return {
    name: "teacher_response",
    strict: true,
    schema: {
      type: "object",
      additionalProperties: false,
      required: ["assistant_reply", "should_correct", "corrections", "new_vocabulary", "follow_up_question"],
      properties: {
        assistant_reply: { type: "string" },
        should_correct: { type: "boolean" },
        corrections: {
          type: "array",
          items: {
            type: "object",
            additionalProperties: false,
            required: [
              "original",
              "highlighted_part",
              "corrected",
              "error_type",
              "explanation_tr",
              "natural_alternative",
              "pronunciation_tip",
              "severity",
            ],
            properties: {
              original: { type: "string" },
              highlighted_part: { type: "string" },
              corrected: { type: "string" },
              error_type: { type: "string" },
              explanation_tr: { type: "string" },
              natural_alternative: { type: ["string", "null"] },
              pronunciation_tip: { type: ["string", "null"] },
              severity: { type: "string", enum: ["low", "medium", "high"] },
            },
          },
        },
        new_vocabulary: {
          type: "array",
          items: {
            type: "object",
            additionalProperties: false,
            required: ["word", "meaning_tr", "example"],
            properties: {
              word: { type: "string" },
              meaning_tr: { type: "string" },
              example: { type: "string" },
            },
          },
        },
        follow_up_question: { type: ["string", "null"] },
      },
    },
  };
}

export function exerciseJsonSchema() {
  return {
    name: "exercise_evaluation",
    strict: true,
    schema: {
      type: "object",
      additionalProperties: false,
      required: ["is_correct", "score", "feedback_tr", "corrected_answer", "explanation_tr", "next_prompt_hint"],
      properties: {
        is_correct: { type: "boolean" },
        score: { type: "number", minimum: 0, maximum: 100 },
        feedback_tr: { type: "string" },
        corrected_answer: { type: "string" },
        explanation_tr: { type: "string" },
        next_prompt_hint: { type: ["string", "null"] },
      },
    },
  };
}

