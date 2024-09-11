import { Tabs } from 'expo-router'
import React from 'react'

const HomeLayout = () => {
    return (
        <Tabs>
            <Tabs.Screen name='home' />
        </Tabs>
    )
}

export default HomeLayout