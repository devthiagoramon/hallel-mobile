import React, { ReactNode } from 'react'
import { SafeAreaView } from 'react-native'

interface ContainerHProps {
    children: ReactNode
}

const ContainerH = ({ children }: ContainerHProps) => {
    return (
        <SafeAreaView style={{ flex: 1 }}>{children}</SafeAreaView>
    )
}

export default ContainerH