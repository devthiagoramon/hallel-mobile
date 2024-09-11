import { LoginDTO } from "types/dtos/user-dtos";
import { api } from "../api-config";

export const isTokenValidService = async (
  token: string
): Promise<boolean | undefined> => {
  try {
    const response: any = await api.get(
      `/public/home/isTokenValid?token=${token}`
    );
    return response.data;
  } catch (error) {
    console.log(error);
    throw new Error("Can't get user infos");
  }
};

export const loginUserService = async (dto: LoginDTO) => {
  try {
    const response = await api.post("/public/login", { ...dto });
    return response.data;
  } catch (error: any) {
    console.log(error);
    throw new Error("Can't login!");
  }
};
