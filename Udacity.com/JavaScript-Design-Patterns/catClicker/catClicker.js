var view;
var model;
$(function () {


  model = {
    cats: null,
    currentCat: null,
    Cat: function (name) {
      this.name = name;
      this.count = 0;
    },
    init: function () {
      model.cats = [new model.Cat('Tom'),
                    new model.Cat('Jerry'),
                    new model.Cat('Paul'),
                    new model.Cat('Mary'),
                    new model.Cat('Hillary Clinton')];
    },

  };

  var controller = {
      init: function () {
        model.init();
        view.init();
      },
      makeMainCat: function (i) {
        return function () {
          console.log('show cat ' + i);
          var mainCat = model.cats[i];
          $('#catContainer').html(
            '<div class="catBox" id="catBox' + i + '">\
          <h2 class="catName" id="catName1">' + mainCat.name + '</h2>\
          <h2 class="count" id="count' + i + '">' + mainCat.count + '</h2>\
          <img class="catPic" id="cat' + i + '" src="cat' + i + '.jpg">\
          </div>'
          );

          $('#cat' + i).click(controller.createCountIncrement(i));
        };
      },
      createCountIncrement: function (i) {
        return function countIncrement() {
          console.log(i);
          model.cats[i].count++;
          $('#count' + i).text(model.cats[i].count);
        };
      }
    };
  view = {
    init: function () {
      this.catList = $('#catList');
      this.currentCat = $('#catContainer');
      view.render();
    },
    render: function () {

      var i;
      for (i = 0; i < model.cats.length; i++) {
        this.catList.append(
          $('<li class="button">').text(model.cats[i].name).click(controller.makeMainCat(i))
        );
      }
    }
  };
  controller.init();
});
