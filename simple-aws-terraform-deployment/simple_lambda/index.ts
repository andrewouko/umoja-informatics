import { APIGatewayProxyEvent, APIGatewayProxyResult } from "aws-lambda";

interface Payload {
  name?: string;
}

export const handler = async (
  event: APIGatewayProxyEvent
): Promise<APIGatewayProxyResult> => {
  console.log("Received event:", JSON.stringify(event, null, 2));
  console.log("Environment variables:", JSON.stringify(process.env, null, 2));

  try {
    const body = JSON.parse(event.body ?? "{}") as Payload;
    const name = body.name ?? "World";
    const response = {
      statusCode: 200,
      body: JSON.stringify({
        message: `Hello, ${name}!`,
      }),
    };
    console.log("Response:", JSON.stringify(response, null, 2));
    return response;
  } catch (error) {
    console.error("Error processing event:", error);
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: "Internal Server Error",
        error: (error as Error).message,
      }),
    };
  }
};
