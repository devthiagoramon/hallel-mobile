
import { Colors } from 'constants/Colors'
import React, { ReactNode } from 'react'
import { ThemeProvider } from 'styled-components'

export type ThemeType = typeof Colors
const theme = Colors

const AppTheme = ({ children }: { children: ReactNode }) => {
    return (
        <ThemeProvider theme={theme}>{children}</ThemeProvider>
    )
}

export default AppTheme