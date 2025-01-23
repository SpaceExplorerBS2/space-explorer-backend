declare global {
  namespace NodeJS {
    interface ProcessEnv {
      OPENAI_API_KEY: string;
      ENV: "dev" | "prod";
    }
  }
}

export {};
