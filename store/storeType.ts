export interface UserReduxType {
    id: string,
    nome: string,
    email: string,
    image: string,
    dataNascimento: string,
    telefone: string,
}

export interface ReduxType{
    user: UserReduxType
}