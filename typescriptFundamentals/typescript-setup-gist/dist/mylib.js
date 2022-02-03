/******/ (() => { // webpackBootstrap
/******/ 	"use strict";
/******/ 	var __webpack_modules__ = ({

/***/ "./src/utils.ts":
/*!**********************!*\
  !*** ./src/utils.ts ***!
  \**********************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "defaultSymbol": () => (/* binding */ defaultSymbol),
/* harmony export */   "defaultLength": () => (/* binding */ defaultLength),
/* harmony export */   "generateRandomId": () => (/* binding */ generateRandomId)
/* harmony export */ });
var defaultSymbol = '#';
var defaultLength = 2;
function generateRandomId(optionsOrSymbol) {
    if (typeof optionsOrSymbol === 'string') {
        return optionsOrSymbol + Math.random().toString(36).substr(2, length);
    }
    return optionsOrSymbol.symbol + Math.random().toString(36).substr(2, optionsOrSymbol.length);
}


/***/ })

/******/ 	});
/************************************************************************/
/******/ 	// The module cache
/******/ 	var __webpack_module_cache__ = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/ 		// Check if module is in cache
/******/ 		var cachedModule = __webpack_module_cache__[moduleId];
/******/ 		if (cachedModule !== undefined) {
/******/ 			return cachedModule.exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = __webpack_module_cache__[moduleId] = {
/******/ 			// no module.id needed
/******/ 			// no module.loaded needed
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		__webpack_modules__[moduleId](module, module.exports, __webpack_require__);
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/************************************************************************/
/******/ 	/* webpack/runtime/define property getters */
/******/ 	(() => {
/******/ 		// define getter functions for harmony exports
/******/ 		__webpack_require__.d = (exports, definition) => {
/******/ 			for(var key in definition) {
/******/ 				if(__webpack_require__.o(definition, key) && !__webpack_require__.o(exports, key)) {
/******/ 					Object.defineProperty(exports, key, { enumerable: true, get: definition[key] });
/******/ 				}
/******/ 			}
/******/ 		};
/******/ 	})();
/******/
/******/ 	/* webpack/runtime/hasOwnProperty shorthand */
/******/ 	(() => {
/******/ 		__webpack_require__.o = (obj, prop) => (Object.prototype.hasOwnProperty.call(obj, prop))
/******/ 	})();
/******/
/******/ 	/* webpack/runtime/make namespace object */
/******/ 	(() => {
/******/ 		// define __esModule on exports
/******/ 		__webpack_require__.r = (exports) => {
/******/ 			if(typeof Symbol !== 'undefined' && Symbol.toStringTag) {
/******/ 				Object.defineProperty(exports, Symbol.toStringTag, { value: 'Module' });
/******/ 			}
/******/ 			Object.defineProperty(exports, '__esModule', { value: true });
/******/ 		};
/******/ 	})();
/******/
/************************************************************************/
var __webpack_exports__ = {};
// This entry need to be wrapped in an IIFE because it need to be isolated against other modules in the chunk.
(() => {
/*!**********************!*\
  !*** ./src/app.ts ***!
  \**********************/
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _utils__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./utils */ "./src/utils.ts");

(0,_utils__WEBPACK_IMPORTED_MODULE_0__.generateRandomId)('#', 7); // overload 1
(0,_utils__WEBPACK_IMPORTED_MODULE_0__.generateRandomId)({ length: 7, symbol: '#' }); // 2
function userAlert() {
    alert('hello');
}
function main() {
    var appComponent = document.getElementById('app');
    setInterval(function () {
        if (appComponent) {
            appComponent.innerHTML = (0,_utils__WEBPACK_IMPORTED_MODULE_0__.generateRandomId)({ symbol: _utils__WEBPACK_IMPORTED_MODULE_0__.defaultSymbol, length: _utils__WEBPACK_IMPORTED_MODULE_0__.defaultLength });
        }
    }, 1000);
}
main();

})();

/******/ })()
;
//# sourceMappingURL=mylib.js.map