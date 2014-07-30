angular.module("template/pagination/pagination.html", []).run(["$templateCache", function($templateCache) {
  $templateCache.put("template/pagination/pagination.html",
    "<ul class=\"pagination\">\n" +
    "  <li ng-repeat=\"page in pages\" ng-class=\"{active: page.active, disabled: page.disabled}\"><a ng-click=\"selectPage(page.number)\">{{page.text}}</a></li>\n" +
    "</ul>\n" +
    "");
}]);
angular.module('ui.bootstrap.carousel', ['ui.bootstrap.transition'])
    .controller('CarouselController', ['$scope', '$timeout', '$transition', '$q', function        ($scope, $timeout, $transition, $q) {
}]).directive('carousel', [function() {
    return {

    }
}]);

  module=angular.module('RestaurantBooking', ['ui.bootstrap']);
  
  module.filter('startFrom', function() {
    return function(input, start) {
        if(input) {
            start = +start; //parse to int
            return input.slice(start);
        }
        return [];
    }
  });

  module.controller('ListRestaurantsController',function($scope, $routeParams, $http,$filter, $location, filterFilter) {
    $scope.restaurants=[];
    // $scope.restaurants={}
    $http({
      method : 'get',
      url : '/api/restaurants/list_restaurants',
    }).success(function(data, status) {
      $scope.activeRestaurants=filterFilter(data, {active:true});
      $scope.restaurants=$filter('orderBy')($scope.activeRestaurants,'name');
      // $scope.restaurants=data.restaurants
    }).error(function(data, status) {
      console.log("error")
    });      
    $scope.getNumber = function(num) {
      return new Array(num);   
    }

    $scope.getStarRating=function(){
      $http({
      method : 'get',
      url : '/api/restaurant_tags?tag=Star'
      }).success(function(data, status) {
        $scope.stars=data;
      }).error(function(data, status) {
        console.log("error")
      });
    };
    $scope.getStarRating();
    $scope.getPrice=function(){
      $http({
      method : 'get',
      url : '/api/restaurant_tags?tag=Price'
      }).success(function(data, status) {
        $scope.prices=data;
      }).error(function(data, status) {
        console.log("error")
      });
    };
    $scope.getPrice();

    $scope.getPayment=function(){
      $http({
      method : 'get',
      url : '/api/restaurant_tags?tag=Payment'
      }).success(function(data, status) {
        $scope.payment_methods=data;
      }).error(function(data, status) {
        console.log("error")
      });
    };
    $scope.getPayment();
    $scope.getCuisine=function(){
      $http({
      method : 'get',
      url : '/api/restaurant_tags?tag=Cuisine'
      }).success(function(data, status) {
        $scope.cuisineTypes=data;
      }).error(function(data, status) {
        console.log("error")
      });
    };
    $scope.getCuisine();
    $scope.getLocation=function(){
      $http({
      method : 'get',
      url : '/api/restaurant_tags?tag=Location'
      }).success(function(data, status) {
        $scope.restaurantLocations=data;
      }).error(function(data, status) {
        console.log("error")
      });
    };
    $scope.getLocation();
    $scope.getmealTypes=function(){
      $http({
      method : 'get',
      url : '/api/restaurant_tags?tag=Meals'
      }).success(function(data, status) {
        $scope.mealTypes=data;
      }).error(function(data, status) {
        console.log("error")
      });
    };
    $scope.getmealTypes();
    $scope.getParking=function(){
      $http({
      method : 'get',
      url : '/api/restaurant_tags?tag=Parking'
      }).success(function(data, status) {
        $scope.parkingType=data;
      }).error(function(data, status) {
        console.log("error")
      });
    };
    $scope.getParking();
    $scope.getDrinking=function(){
      $http({
      method : 'get',
      url : '/api/restaurant_tags?tag=Drinking'
      }).success(function(data, status) {
        $scope.drinkingTypes=data;
      }).error(function(data, status) {
        console.log("error")
      });
    };
    $scope.getDrinking();
    $scope.getMisc=function(){
      $http({
      method : 'get',
      url : '/api/restaurant_tags?tag=Misc'
      }).success(function(data, status) {
        $scope.miscTypes=data;
      }).error(function(data, status) {
        console.log("error")
      });
    };
    $scope.getMisc();
    $scope.getAdmin=function(){
      $http({
      method : 'get',
      url : '/api/restaurant_tags?tag=Admin'
      }).success(function(data, status) {
        $scope.adminTypes=data;
        console.log($scope.adminTypes);
      }).error(function(data, status) {
        console.log("error")
      });
    };
    $scope.getAdmin();

    $scope.converToInt = function(value){
      return  parseInt(value, 10); ;
    };

    $scope.getFloatContain = function(value)
    {
      if(parseFloat(value)-parseInt(value)>0)
        return true;
      else
        return false;
    }
    $scope.currentPage = 1; //current page
    $scope.maxSize = 10; //pagination max size
    $scope.entryLimit = 10; //max rows for data table

    /* init pagination with $scope.list */
    $scope.noOfPages = Math.ceil($scope.restaurants.length/$scope.entryLimit);
    
    $scope.$watch('restaurants', function(term) {
        // Create $scope.filtered and then calculat $scope.noOfPages, no racing!
      $scope.filtered = $scope.restaurants;
      $scope.noOfPages = Math.ceil($scope.filtered.length/$scope.entryLimit);
      $scope.changePage(1);
    });


    $scope.selectedStars = {};
    $scope.selectedPrices = {};
    $scope.selectedPayments = {};
    $scope.selectedCuisines = {};
    $scope.selectedLocations={};
    $scope.selectedMeals={};
    $scope.selectedParking={};
    $scope.selectedDrinking={};
    $scope.selectedMisc={};
    $scope.selectedAdmin={};
    $scope.$watch(function () {
        return {
            restaurants: $scope.restaurants,
            selectedStars: $scope.selectedStars,
            selectedPrices: $scope.selectedPrices,
            selectedPayments: $scope.selectedPayments,
            selectedCuisines: $scope.selectedCuisines,
            selectedLocations: $scope.selectedLocations,
            selectedMeals: $scope.selectedMeals,
            selectedParking: $scope.selectedParking,
            selectedDrinking: $scope.selectedDrinking,
            selectedMisc: $scope.selectedMisc,
            selectedAdmin: $scope.selectedAdmin
        }
    }, function (value) {
      var selected;
      
      $scope.count = function (prop, value) {
        return function (el) {
          return el[prop] == value;
        };
      };
      
      $scope.groupByStar = uniqueItems($scope.restaurants, 'star_float');
      var filterAfterStar = [];        
      selected = false;
      // console.log($scope.selectedStars);
      for (var j in $scope.restaurants) {
        var p = $scope.restaurants[j];
        for (var i in $scope.selectedStars) {
          if ($scope.selectedStars[i]) {
            selected = true;
            if (i == p.star_float) {
              filterAfterStar.push(p);
              break;
            }
          }
        }        
      }
      if (!selected) {
        filterAfterStar = $scope.restaurants;
      }
      $scope.groupByPrice = uniqueItems($scope.restaurants, 'price');
      var filterAfterPrice = [];        
      selected = false;
      for (var j in filterAfterStar) {
        var p = filterAfterStar[j];
        for (var i in $scope.selectedPrices) {
          if ($scope.selectedPrices[i]) {
            selected = true;
            if (i == p.price) {
              filterAfterPrice.push(p);
              break;
            }
          }
        }       
      }
      if (!selected) {
          filterAfterPrice = filterAfterStar;
      }

      $scope.groupByPayment = uniqueItems($scope.restaurants, 'Payment');
      var filterAfterPayment = []; 
      selected = false;
      for (var j in filterAfterPrice) {
        var p = filterAfterPrice[j];
        for (var i in $scope.selectedPayments) {
          var isValueSet=false;       
          if ($scope.selectedPayments[i]) {
            selected = true;
            angular.forEach(p.tags, function(tag) {
              if( tag.indexOf("Payment:"+i) >= 0 ) 
                filterAfterPayment.push(p);

            });
            if(isValueSet) {
              break;
            }
          }
        }    
      }
      if (!selected) {
        filterAfterPayment = filterAfterPrice;
      }  
      $scope.groupByCuisineType = uniqueItems($scope.restaurants, 'Cuisine');
      var filterAfterCuisines = []; 
      selected = false;
      for (var j in filterAfterPayment) {
        var p = filterAfterPayment[j];
        for (var i in $scope.selectedCuisines) {
          var isValueSet=false;       
          if ($scope.selectedCuisines[i]) {
            selected = true;
            angular.forEach(p.tags, function(tag) {
              if( tag.indexOf("Cuisine:"+i) >= 0 )
              { 
                filterAfterCuisines.push(p);
              }
            });
            if(isValueSet) {
              break;
            }
          }
        }    
      }
      if (!selected) {
        filterAfterCuisines = filterAfterPayment;
      } 
      $scope.groupByLocation = uniqueItems($scope.restaurants, 'Location');
      var filterAfterLocations = []; 
      selected = false;
      for (var j in filterAfterCuisines) {
        var p = filterAfterCuisines[j];
        for (var i in $scope.selectedLocations) {
          var isValueSet=false;       
          if ($scope.selectedLocations[i]) {
            selected = true;
            angular.forEach(p.tags, function(tag) {
              if( tag.indexOf("Location:"+i) >= 0 )
              { 
                filterAfterLocations.push(p);
              }
            });
            if(isValueSet) {
              break;
            }
          }
        }    
      }
      if (!selected) {
        filterAfterLocations = filterAfterCuisines;
      }
      $scope.groupByMeals = uniqueItems($scope.restaurants, 'Meal');
      var filterAfterMeals = []; 
      selected = false;
      for (var j in filterAfterLocations) {
        var p = filterAfterLocations[j];
        for (var i in $scope.selectedMeals) {
          var isValueSet=false;       
          if ($scope.selectedMeals[i]) {
            selected = true;
            angular.forEach(p.tags, function(tag) {
              if( tag.indexOf("Meals:"+i) >= 0 )
              { 
                filterAfterMeals.push(p);
              }
            });
            if(isValueSet) {
              break;
            }
          }
        }    
      }
      if (!selected) {
        filterAfterMeals = filterAfterLocations;
      }
      $scope.groupByParking = uniqueItems($scope.restaurants, 'Parking');
      var filterAfterParking = []; 
      selected = false;
      for (var j in filterAfterMeals) {
        var p = filterAfterMeals[j];
        for (var i in $scope.selectedParking) {
          var isValueSet=false;       
          if ($scope.selectedParking[i]) {
            selected = true;
            angular.forEach(p.tags, function(tag) {
              if( tag.indexOf("Parking:"+i) >= 0 )
              { 
                filterAfterParking.push(p);
              }
            });
            if(isValueSet) {
              break;
            }
          }
        }    
      }
      if (!selected) {
        filterAfterParking = filterAfterMeals;
      }      
      $scope.groupByDrinking = uniqueItems($scope.restaurants, 'Drinking');
      var filterAfterDrinking= []; 
      selected = false;
      for (var j in filterAfterParking) {
        var p = filterAfterParking[j];
        for (var i in $scope.selectedDrinking) {
          var isValueSet=false;       
          if ($scope.selectedDrinking[i]) {
            selected = true;
            angular.forEach(p.tags, function(tag) {
              if( tag.indexOf("Drinking:"+i) >= 0 )
              { 
                filterAfterDrinking.push(p);
              }
            });
            if(isValueSet) {
              break;
            }
          }
        }    
      }
      if (!selected) {
        filterAfterDrinking = filterAfterParking;
      }
      $scope.groupByMisc = uniqueItems($scope.restaurants, 'Misc');
      var filterAfterMisc= []; 
      selected = false;
      for (var j in filterAfterDrinking) {
        var p = filterAfterDrinking[j];
        for (var i in $scope.selectedMisc) {
          var isValueSet=false;       
          if ($scope.selectedMisc[i]) {
            selected = true;
            angular.forEach(p.tags, function(tag) {
              if( tag.indexOf("Misc:"+i) >= 0 )
              { 
                filterAfterMisc.push(p);
              }
            });
            if(isValueSet) {
              break;
            }
          }
        }    
      }
      if (!selected) {
        filterAfterMisc = filterAfterDrinking;
      }  
      $scope.groupByAdmin = uniqueItems($scope.restaurants, 'Admin');
      var filterAfterAdmin= []; 
      selected = false;
      for (var j in filterAfterMisc) {
        var p = filterAfterMisc[j];
        for (var i in $scope.selectedAdmin) {
          var isValueSet=false;       
          if ($scope.selectedAdmin[i]) {
            selected = true;
            angular.forEach(p.tags, function(tag) {
              if( tag.indexOf("Admin:"+i) >= 0 )
              { 
                filterAfterAdmin.push(p);
              }
            });
            if(isValueSet) {
              break;
            }
          }
        }    
      }
      if (!selected) {
        filterAfterAdmin = filterAfterMisc;
      } 
      $scope.filtered=filterAfterAdmin;     
    }, true);
    
    
    $scope.$watch('filtered', function (newValue) {
        if (angular.isArray(newValue)) {
          $scope.changePage(1);
          $scope.noOfPages = Math.ceil($scope.filtered.length/$scope.entryLimit);
        }
    }, true);   

    $scope.changePage=function(pageNumber){
      $scope.imageTagString = "http://maps.google.com/maps/api/staticmap?key=AIzaSyC77WBfl-zki0vS7h9zyKyYg3htKcERvuo&size=550x550";
      var maxLength=0;
      if((pageNumber*10)>$scope.filtered.length)
        maxLength=$scope.filtered.length;
      else
        maxLength=pageNumber*10;
      for(var i=((pageNumber-1)*10); i<maxLength;i++)
      {
        $scope.imageTagString+="&markers=icon:http://i42.tinypic.com/rj2txf.png%7C"+$scope.filtered[i].lat+"%2C"+$scope.filtered[i].lng
      }
    }

  });

var uniqueItems = function (data, key) {
  var result = [];
  for (var i = 0; i < data.length; i++) {
    var value = data[i][key];
    if (result.indexOf(value) == -1) {
      result.push(value);
    }
  }
  return result;
};



