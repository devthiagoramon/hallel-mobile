import LogoHallel from "assets/images/logo-hallel.png";
import ButtonH from "components/ButtonH";
import LabelInputH from "components/LabelInputH";
import PasswordInputPaper from "components/PasswordInputPaper";
import { Colors } from "constants/Colors";
import { router } from "expo-router";
import React, { useState } from "react";
import { Pressable } from "react-native";
import { IconButton, Snackbar, TextInput } from "react-native-paper";
import { loginUserService } from "service/user/user-service";
import { LoginDTO } from "types/dtos/user-dtos";
import {
    LoginForgetPasswordText,
    LoginSignUpButtonContainer,
    LoginSignUpContainer,
    LoginSignUpContainerBackIcon,
    LoginSignUpForms,
    LoginSignUpFormsContainer,
    LoginSignUpFormsTitle,
    LoginSignUpImage,
    LoginSignUpImageContainer,
} from "./login-signUp-style";

const Login = () => {

    const [FEmail, setFEmail] = useState<string>("")
    const [FPassword, setFPassword] = useState<string>("")

    const [EEmail, setEEmail] = useState<boolean>(false)
    const [EPassword, setEPassword] = useState<boolean>(false)

    const [snackBarError, setSnackBarError] = useState<string | undefined>(undefined)
    const showSnackBarError = Boolean(snackBarError)

    const enqueueSnackBar = (value: string) => {
        setSnackBarError(value)
    }

    const validateForms = () => {
        let valid = true
        if (FEmail === "") {
            setEEmail(true)
            enqueueSnackBar("Digite o seu e-mail!")
            valid = false
        } else {
            setEEmail(false)
        }
        if (FPassword === "") {
            setEPassword(true)
            enqueueSnackBar("Digite a sua senha!")
            valid = false
        } else {
            setEPassword(false)
        }
        return valid
    }

    const submitForms = async () => {
        if (!validateForms()) return

        try {
            const dto: LoginDTO = {
                email: FEmail,
                senha: FPassword,
            }
            const response = await loginUserService(dto)
            console.log(response)
            if (response) {
                router.navigate("/(home)")
            } else {

            }
        } catch (error) {
            console.log(error)
        }

    }



    return (
        <LoginSignUpContainer>
            <LoginSignUpContainerBackIcon >
                <IconButton onPress={router.back} size={36} iconColor={Colors.light.whiteText} icon={"chevron-left"} />
            </LoginSignUpContainerBackIcon>
            <LoginSignUpImageContainer>
                <LoginSignUpImage source={LogoHallel} />
            </LoginSignUpImageContainer>
            <LoginSignUpFormsContainer>
                <LoginSignUpForms>
                    <LoginSignUpFormsTitle>Login</LoginSignUpFormsTitle>
                    <LabelInputH color="white">E-mail</LabelInputH>
                    <TextInput
                        id="login-e-mail"
                        value={FEmail}
                        onChangeText={text => setFEmail(text)}
                        mode="outlined"
                        error={EEmail}
                        style={{ backgroundColor: "#033017" }}
                        textColor={Colors.light.whiteText}
                        outlineColor={Colors.light.whiteText}
                        activeOutlineColor={Colors.light.secondary}
                    />
                    <LabelInputH color="white">Senha</LabelInputH>
                    <PasswordInputPaper
                        id="login-password"
                        value={FPassword}
                        onChangeText={text => setFPassword(text)}
                        mode="outlined"
                        error={EPassword}
                        style={{ backgroundColor: "#033017" }}
                        textColor={Colors.light.whiteText}
                        outlineColor={Colors.light.whiteText}
                        activeOutlineColor={Colors.light.secondary}
                        iconColor={Colors.light.whiteText}
                    />
                    <Pressable>
                        <LoginForgetPasswordText>Esqueceu a senha?</LoginForgetPasswordText>
                    </Pressable>
                </LoginSignUpForms>
            </LoginSignUpFormsContainer>
            <LoginSignUpButtonContainer>
                <ButtonH onPress={submitForms} style={{ width: "60%" }} color="success" variant="contained">
                    Entrar
                </ButtonH>
            </LoginSignUpButtonContainer>
            <Snackbar
                duration={4000}
                onDismiss={() => setSnackBarError(undefined)}
                visible={showSnackBarError}
                style={{ backgroundColor: Colors.light.error }}
            >
                {snackBarError}
            </Snackbar>
        </LoginSignUpContainer>
    );
};

export default Login;
