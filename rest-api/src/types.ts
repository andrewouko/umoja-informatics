export enum Role {
  Author = "author",
  User = "user",
}
export interface User {
  name: string;
  email: string;
  role: Role;
}
