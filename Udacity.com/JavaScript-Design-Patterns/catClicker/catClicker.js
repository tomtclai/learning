/*jslint browser:true */

var model, controller, catView, catListView, adminView;
model = {
    cats: null,
    currentCat: null,
    Cat: function(name, img) {
        this.name = name;
        this.count = 0;
        this.img = img;
    },
    init: function() {
        model.cats = [new model.Cat('Tom', 'cat0.jpg'),
            new model.Cat('Jerry', 'cat1.jpg'),
            new model.Cat('Paul', 'cat2.jpg'),
            new model.Cat('Mary', 'cat3.jpg'),
            new model.Cat('Hillary Clinton', 'cat4.jpg')
        ];
    },
};

controller = {
    init: function() {
        model.init();
        catListView.init();
        catView.init();
        adminView.init();
        controller.hideAdminPane();
    },

    getCurrentCat: function() {
        return model.currentCat;
    },
    getCurrentCatName: function() {
        return model.currentCat.name;
    },
    getCurrentCatImgSrc: function() {
        return model.currentCat.img;
    },
    getCurrentCatClickCount: function() {
        return model.currentCat.count;
    },
    getCats: function() {
        return model.cats;
    },

    setCurrentCat: function(cat) {
        model.currentCat = cat;
        catView.render();
    },
    setCurrentCatName: function(name) {
        model.currentCat.name = name;
        catView.render();
        catListView.render();
    },
    setCurrentCatImgSrc: function(img) {
        model.currentCat.img = img;
        catView.render();
    },
    setCurrentCatClickCount: function(count) {
        model.currentCat.count = count;
        catView.render();
    },
    incrementCounter: function() {
        model.currentCat.count++;
        catView.render();
    },
    hideAdminPane: function() {
        $(adminView.parentView).hide();
    },
    showAdminPane: function() {
        $(adminView.parentView).show();
    },
    adminButtonClicked: function() {
        adminView.init();
        controller.showAdminPane();
    },
    renderAdmin: function() {
        adminView.render();
    }
};

catView = {
    init: function() {
        this.catBox = $('#catBox');
        this.catName = $('#catName');
        this.count = $('#count');
        this.img = $('#cat');
        this.img.click(function() {
            controller.incrementCounter();
        });
        this.adminButton = $('#showAdminView');
        $(this.adminButton).click(controller.adminButtonClicked);
        this.render();
    },
    render: function() {
        var currentCat = controller.getCurrentCat();
        if (currentCat) {
            this.count.text(currentCat.count);
            this.catName.text(currentCat.name);
            this.img.attr('src', currentCat.img);
            $(this.adminButton).css('display', '');
            // this.adminButton.value('Admin');
            $()
        }
        controller.renderAdmin();

    }
};

catListView = {
    init: function() {
        this.catList = $('#catList');
        this.render();
    },
    render: function() {
        var cat, elem, i;
        var cats = controller.getCats();

        $(this.catList).text('');

        for (i = 0; i < cats.length; i++) {
            cat = cats[i];

            elem = document.createElement('li');
            elem.textContent = cat.name;

            $(elem).click(
                makeCatClickHandler(cat)
            );

            this.catList.append(elem);
        }

        function makeCatClickHandler(catCopy) {
            return function() {
                controller.setCurrentCat(catCopy);
                catView.render();
            };
        }
    }
};

adminView = {
    init: function() {
        this.parentView = $('#adminForm');
        $('#adminForm').hide();
        this.nameLabel = $('#changeName');
        this.newName = $('#newName');
        this.urlLabel = $('#changeURL');
        this.newURL = $('#newURL');
        this.numberLabel = $('#changeNumber');
        this.newNumber = $('#newNumber');
        this.render();
        console.log('adminview init');
        $('#dismiss').click(controller.hideAdminPane);
        $('#submit').click(adminView.saveButtonPressed);

    },
    render: function() {
        // $('#adminForm').css('visibility', '');
        if (controller.getCurrentCat) {
            this.nameLabel.text('Cat Name');
            $(this.newName).val(controller.getCurrentCatName);
            this.urlLabel.text('Image Source');
            $(this.newURL).val(controller.getCurrentCatImgSrc);
            this.numberLabel.text('Click Count');
            $(this.newNumber).val(controller.getCurrentCatClickCount);
        }
    },
    saveButtonPressed: function() {
        adminView.saveChanges();
        $(this.parentView)
    },
    saveChanges: function() {
        controller.setCurrentCatName($(adminView.newName).val());
        controller.setCurrentCatImgSrc($(adminView.newURL).val());
        controller.setCurrentCatClickCount($(adminView.newNumber).val());
    }
}

$(document).ready(function() {
    controller.init();
});
