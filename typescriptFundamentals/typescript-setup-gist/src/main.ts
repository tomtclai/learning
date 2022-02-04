interface Person {
    name: string
    age: number
}

type keys = keyof Person

const foo = {
    x: true,
}

function getProperty<T, K extends keyof T>(obj: T, key: K) {
    return obj[key]
}

getProperty(foo, 'x')

const obj: object = {}
