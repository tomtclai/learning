import {generateRandomId, defaultLength, defaultSymbol} from './utils'

generateRandomId('#', 7) // overload 1
generateRandomId({ length: 7, symbol: '#' }) // 2

function userAlert() {
    alert('hello')
}
function main() {
    var appComponent = document.getElementById('app')
    setInterval(function () {
        if (appComponent) {
            appComponent.innerHTML = generateRandomId({ symbol:defaultSymbol, length: defaultLength })
        }
    }, 1000)
}

main()