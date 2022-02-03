import {generateRandomId, defaultLength, defaultSymbol, Component} from './utils'


generateRandomId('#', 7) // overload 1
generateRandomId({ length: 7, symbol: '#' }) // 2

function enumerable(isEnumerable: boolean) {
    return (
        target: any,
        propertyKey: any,
        propertyDescriptor: PropertyDescriptor
    ) => {
        propertyDescriptor.enumerable = isEnumerable
    }
}

function prop(x :any , name:any) {
    console.log('x '+x);
    console.log('name '+name);
}

function param(x: any, name: any, index: number) {
    console.log('x '+JSON.stringify(x));
    console.log('name ' + name);
    console.log('i '+index);
}
@Component({id: 'app'})
class App {
    @prop
    static version: string;

    static id: string
    @enumerable(false)
    onInit(@param elements: HTMLElement | null) {
        setInterval(function () {
            if (elements) {
                elements.innerHTML = generateRandomId({ symbol:defaultSymbol, length: defaultLength })
            }
        }, 1000)
    }
}

function userAlert() {
    alert('hello')
}

for (let key in App.prototype) {
    console.log(key);
}

function main(ComponentClass: typeof App) {
    var element = document.getElementById(ComponentClass.id)
    const cmp = new ComponentClass()
    cmp.onInit(element)

}

main(App)