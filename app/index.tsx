import LogoHallel from 'assets/images/logo-hallel.png';
import ButtonH from 'components/ButtonH';
import ContainerH from 'components/ContainerH';
import { router } from 'expo-router';
import React, { useEffect } from 'react';
import { getTokenUser } from 'service/storage/user/storage-user';
import { isTokenValidService } from 'service/user/user-service';
import { MainPageBottomContainer, MainPageBottomContainerButtons, MainPageBottomContainerTitle, MainPageContainer, MainPageImage, MainPageImageContainer } from './main-style';

const MainPage = () => {

    useEffect(() => {
        async function verifyTokenUser() {
            try {
                const token = await getTokenUser()
                if (token) {
                    const validateToken = await isTokenValidService(token);
                    if (validateToken) {
                        router.navigate("/")
                    }
                }
            } catch (error) {
                console.log(error)
            }
        }
        verifyTokenUser()
    }, [])


    return (
        <ContainerH>
            <MainPageContainer>
                <MainPageImageContainer>
                    <MainPageImage source={LogoHallel} />
                </MainPageImageContainer>
                <MainPageBottomContainer>
                    <MainPageBottomContainerTitle >
                        Olá, seja bem vindo
                    </MainPageBottomContainerTitle>
                    <MainPageBottomContainerButtons>
                        <ButtonH color='primaryLight' variant='contained'>
                            Cadastrar
                        </ButtonH>
                        <ButtonH onPress={() => router.navigate("/login")} variant='contained' color='primary'>
                            Entrar
                        </ButtonH>
                    </MainPageBottomContainerButtons>
                </MainPageBottomContainer>
            </MainPageContainer>
        </ContainerH>
    )
}

export default MainPage