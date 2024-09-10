import { createSlice } from "@reduxjs/toolkit";
import { ReduxType, UserReduxType } from "./storeType";

const initialState: UserReduxType = {
    dataNascimento: "",
    email: "",
    id: "",
    image: "",
    nome: "",
    telefone: "",
}

const userSlice = createSlice({
    initialState,
    name: "user",
    reducers: {
        saveInfosUser(state, action){
            const payload = action.payload;
            state.dataNascimento = payload.dataNascimento
            state.email = payload.email
            state.id = payload.id
            state.image = payload.image
            state.telefone = payload.telefone
            state.nome = payload.nome
        }
    }
})

export const {saveInfosUser} = userSlice.actions

export const getUserRedux = (store:ReduxType) => store.user
export const getUserImageRedux = (store:ReduxType) => store.user.image

export default userSlice.reducer