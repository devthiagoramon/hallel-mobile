import AppTheme from 'components/AppTheme'
import { Stack } from 'expo-router'
import React from 'react'
import { Provider } from 'react-redux'
import store from 'store/store'

const RootLayout = () => {
    return (
        <Provider store={store}>
            <AppTheme>
                <Stack screenOptions={{ headerShown: false }}>
                    <Stack.Screen name='index' />
                    <Stack.Screen name='login' />
                </Stack>
            </AppTheme>
        </Provider>
    )
}

export default RootLayout