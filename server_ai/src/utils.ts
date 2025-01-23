import OpenAI from "openai";
import fs from "fs";

const client = new OpenAI();
const model = "gpt-4o";

async function get_prompt(name: string) {
  return fs.readFileSync(`assets/${name}.txt`, "utf-8");
}

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
    model,
    response_format: {
      type: "json_object",
    },
  });

  return chatCompletion?.choices[0]?.message?.content;
}

async function translate_to_alien(text: string): Promise<string | null> {
  const chatCompletion = await client.chat.completions.create({
    messages: [
      {
        role: "system",
        content: await get_prompt("alien_translation_prompt"),
      },
      { role: "user", content: text },
    ],
    model,
  });

  return chatCompletion?.choices[0]?.message?.content;
}

type Voice = "default";
async function text_to_speech(
  text: string,
  voice: Voice = "default"
): Promise<Buffer> {
  return fs.readFileSync("assets/audio1.mp3");
}

export { generate_planet, translate_to_alien, text_to_speech };
