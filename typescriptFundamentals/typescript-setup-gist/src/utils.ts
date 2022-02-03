type ValidSymbol = '#' | '$'
export const defaultSymbol: ValidSymbol = '#'
export var defaultLength: number = 7

export function generateRandomId(symbol: ValidSymbol, length: number): string // 1
export function generateRandomId(options: GenerateConfig): string // 2
export function generateRandomId(optionsOrSymbol: GenerateConfig | ValidSymbol): string {
    if (typeof optionsOrSymbol === 'string') {
        return optionsOrSymbol + Math.random().toString(36).substr(2,length)
    }
    return optionsOrSymbol.symbol + Math.random().toString(36).substr(2,optionsOrSymbol.length)
}

export function Component(options: { id: string }) {
    console.log(options)
    return (target: any) => {
        target.id = options.id
        console.log(target)
    }
}

interface GenerateConfig {
    symbol: ValidSymbol
    length: number
}
