angular.module('routerApp', ['routerRoutes'])

// create the controllers
// this will be the controller for the ENTIRE site
.controller('mainController', function() {
    var vm = this;

    // create a bigMessage variable to display in our view

    vm.bigMessage = 'A smooth sea never made a skilled sailer.';
})

// home page specific controller
.controller('homeController', function() {
    var vm = this;

    vm.message = 'This is the home page!';
})

.controller('aboutController', function() {
    var vm = this;

    vm.message = 'Look! I am an about page.';
})

// contact page controller
.controller('contactController', function() {
    var vm = this;

    vm.message = 'Contact us! JK this is just a demo.';
});
