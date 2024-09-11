import LogoHallel from "assets/images/logo-hallel.png"
import ButtonH from 'components/ButtonH'
import LabelInputH from 'components/LabelInputH'
import PasswordInputPaper from 'components/PasswordInputPaper'
import { Colors } from 'constants/Colors'
import { router } from 'expo-router'
import React from 'react'
import { Pressable } from 'react-native'
import { IconButton, TextInput } from 'react-native-paper'
import { LoginForgetPasswordText, LoginSignUpButtonContainer, LoginSignUpContainer, LoginSignUpContainerBackIcon, LoginSignUpForms, LoginSignUpFormsContainer, LoginSignUpFormsTitle, LoginSignUpImage, LoginSignUpImageContainer } from './login-signUp-style'

const SignUp = () => {
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
                    <LoginSignUpFormsTitle>Cadastro</LoginSignUpFormsTitle>
                    <LabelInputH color="white">E-mail</LabelInputH>
                    <TextInput
                        id="login-e-mail"
                        mode="outlined"
                        style={{ backgroundColor: "#033017" }}
                        textColor={Colors.light.whiteText}
                        outlineColor={Colors.light.whiteText}
                        activeOutlineColor={Colors.light.secondary}
                    />
                    <LabelInputH color="white">Senha</LabelInputH>
                    <PasswordInputPaper
                        id="login-password"
                        mode="outlined"
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
                <ButtonH style={{ width: "60%" }} color="success" variant="contained">
                    Entrar
                </ButtonH>
            </LoginSignUpButtonContainer>
        </LoginSignUpContainer>
    )
}

export default SignUp