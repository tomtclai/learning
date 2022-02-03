import {generateRandomId, defaultLength, defaultSymbol} from './utils'

generateRandomId('#', 7) // overload 1
generateRandomId({ length: 7, symbol: '#' }) // 2

class App {
    static id = 'app';
    onInit(elements: HTMLElement | null) {
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
function main(ComponentClass: typeof App) {
    var element = document.getElementById(ComponentClass.id)
    const cmp = new ComponentClass()
    cmp.onInit(element)

}

main(App)