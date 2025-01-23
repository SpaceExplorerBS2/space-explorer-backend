import Fastify from "fastify";
import {
  generate_planet,
  text_to_speech,
  translate_to_alien,
} from "./utils.js";

const app = Fastify({
  logger: {
    transport: {
      target: "pino-pretty",
    },
  },
});

interface AiPlanetQuery {
  question: string;
}

app.get<{
  Querystring: AiPlanetQuery;
}>("/ai/planet", {
  handler: async (req, reply) => {
    const answerResult = await generate_planet(req.query.question);

    if (!answerResult) {
      return reply.code(500).send("Error generating planet");
    }

    reply.send(JSON.parse(answerResult));
  },
  schema: {
    querystring: {
      type: "object",
      required: ["question"],
      properties: {
        question: { type: "string" },
      },
    },
  },
});

interface AiAlienLanguageQuery {
  text: string;
}

app.get<{
  Querystring: AiAlienLanguageQuery;
}>("/ai/translate", {
  handler: async (req, reply) => {
    const answerResult = await translate_to_alien(req.query.text);

    if (!answerResult) {
      return reply.code(500).send("Error generating translation");
    }

    reply.send(answerResult);
  },
  schema: {
    querystring: {
      type: "object",
      required: ["text"],
      properties: {
        text: { type: "string" },
      },
    },
  },
});

interface AiTextToSpeechQuery {
  text: string;
}

app.get<{
  Querystring: AiTextToSpeechQuery;
}>("/ai/text-to-speech", {
  handler: async (req, reply) => {
    const answerResult = await text_to_speech(req.query.text);

    if (!answerResult) {
      return reply.code(500).send("Error generating translation");
    }

    reply.type("audio/mpeg");
    reply.send(answerResult);
  },
  schema: {
    querystring: {
      type: "object",
      required: ["text"],
      properties: {
        text: { type: "string" },
      },
    },
  },
});

app.listen({
  port: 3000,
  host: process.env.ENV === "dev" ? "127.0.0.1" : "0.0.0.0",
});

export default app;
