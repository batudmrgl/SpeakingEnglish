type ResponseFormatSchema = {
  name: string;
  strict: boolean;
  schema: Record<string, unknown>;
};

export async function createStructuredResponse(
  instructions: string,
  input: unknown,
  jsonSchema: ResponseFormatSchema,
): Promise<unknown> {
  const apiKey = Deno.env.get("OPENAI_API_KEY");
  if (!apiKey) {
    throw new Error("OPENAI_API_KEY is missing");
  }

  const model = Deno.env.get("OPENAI_MODEL") ?? "gpt-4.1-mini";
  const response = await fetch("https://api.openai.com/v1/responses", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${apiKey}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      model,
      instructions,
      input: JSON.stringify(input),
      text: {
        format: {
          type: "json_schema",
          ...jsonSchema,
        },
      },
    }),
  });

  if (!response.ok) {
    const errorText = await response.text();
    throw new Error(`OpenAI request failed: ${response.status} ${errorText}`);
  }

  const data = await response.json();
  const outputText = data.output_text;
  if (typeof outputText !== "string") {
    throw new Error("OpenAI response did not include output_text");
  }

  return JSON.parse(outputText);
}

