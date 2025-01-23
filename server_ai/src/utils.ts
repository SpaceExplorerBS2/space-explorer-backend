import { config } from "dotenv";
import OpenAI from "openai";
import path from "path";

const client = new OpenAI();

async function generate_planet(prompt: string): Promise<string | null> {
  const chatCompletion = await client.chat.completions.create({
    messages: [
      {
        role: "system",
        content: `You are a generator planet generator for an Space epxlorer game.
          You return everytime a json object with the following structure:
          {
            "name": "string",
            "specialEffects": ["string", "string", "string"],
          }`,
      },
      { role: "user", content: prompt },
    ],
    model: "gpt-4o",
    response_format: {
      type: "json_object",
    },
  });

  return chatCompletion?.choices[0]?.message?.content;
}

export { generate_planet };
