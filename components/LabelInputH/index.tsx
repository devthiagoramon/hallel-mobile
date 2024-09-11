import React, { ReactNode } from 'react'
import { LabelInputHComponent } from './style'

interface LabelInputHProps {
    color?: "white" | "black"
    children: string | ReactNode
}

const LabelInputH = ({ color = "black", children }: LabelInputHProps) => {
    return (
        <LabelInputHComponent $color={color}>{children}</LabelInputHComponent>
    )
}

export default LabelInputH