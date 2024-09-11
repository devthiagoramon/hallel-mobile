import AppTheme from 'components/AppTheme'
import { Colors } from 'constants/Colors'
import { Stack } from 'expo-router'
import React from 'react'
import { DefaultTheme, PaperProvider } from 'react-native-paper'
import { Provider } from 'react-redux'
import store from 'store/store'

const RootLayout = () => {

    const paperTheme = {
        ...DefaultTheme,
        colors: {
            ...DefaultTheme.colors,
            primary: Colors.light.principal,
            secondary: Colors.light.secondary,
            tertiary: Colors.light.secondaryLigth
        }
    }

    return (
        <Provider store={store}>
            <PaperProvider theme={paperTheme}>
                <AppTheme>
                    <Stack screenOptions={{ headerShown: false }}>
                        <Stack.Screen name='index' />
                        <Stack.Screen name='login' />
                    </Stack>
                </AppTheme>
            </PaperProvider>
        </Provider>
    )
}

export default RootLayout