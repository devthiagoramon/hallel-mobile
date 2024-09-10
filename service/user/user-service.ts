import { api } from "../api-config";

export const isTokenValidService = async (token:string): Promise<boolean| undefined> => {
    try {
        const response:any = await api.get(`/public/home/isTokenValid?token=${token}`)
        return response.data;
    } catch (error) {
        console.log(error)
        throw new Error("Can't get user infos");
    }
}