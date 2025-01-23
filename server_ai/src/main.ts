import Fastify from "fastify";
import { generate_planet } from "./utils.js";

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

app.listen({
  port: 3000,
  host: process.env.NODE_ENV === "production" ? "0.0.0.0" : "127.0.0.1",
});

console.log(process.env.NODE_ENV);

export default app;
