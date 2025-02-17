import { APIGatewayProxyEvent, APIGatewayProxyResult } from "aws-lambda";

interface Payload {
    name?: string;
}

export const handler = async (
  event: APIGatewayProxyEvent
): Promise<APIGatewayProxyResult> => {
  const body = JSON.parse(event.body ?? "{}") as Payload;
  const name = body.name ?? "World";
  const response = {
    statusCode: 200,
    body: JSON.stringify({
      message: `Hello, ${name}!`,
      environment: process.env.ENV,
    }),
  };
  return response;
};
