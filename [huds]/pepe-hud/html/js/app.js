$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESC
            //Inventory.Close();
            break;
    }
});

var moneyTimeout = null;
var CurrentProx = 0;

(() => {
    QBHud = {};

    QBHud.Open = function(data) {
        $(".money-cash").css("display", "block");
        // $(".money-bank").css("display", "block");
        $("#cash").html(data.cash);
        // $("#bank").html(data.bank);
    };

    QBHud.Close = function() {

    };

    QBHud.Show = function(data) {
        if(data.type == "cash") {
            $(".money-cash").fadeIn(150);
            $("#cash").html(data.cash);
            setTimeout(function() {
                $(".money-cash").fadeOut(750);
            }, 3500)
        } 
    };

    QBHud.ToggleSeatbelt = function(data) {
        if (data.seatbelt) {
        } else {
        }
    };

    QBHud.CarHud = function(data) {
        if (data.show) {
            $(".ui-car-container").fadeIn();
            $(".hnitrous").fadeIn(3000);
        } else {
            $(".ui-car-container").fadeOut();
            $('.hnitrous').fadeOut(3000);
        }
    };

    QBHud.UpdateHud = function(data) {
        var Show = "block";
        if (data.show) {
            Show = "none";
            $(".ui-container").css("display", Show);
            return;
        }
        $(".ui-container").css("display", Show);

        // HP Bar
        Progress(data.health - 100, ".hp");
        if (data.health <= 197) {
            $('.hvida').fadeIn(3000);
        }
        if (data.health >= 198) {
            $('.hvida').fadeOut(3000);
        }
        if (data.health <= 50) {
            $('.vida').css("stroke", "red");
        } else {
            $('.vida').css("stroke", "#498949");
        }

        if (data.talking) {
            $(".mic").css({"stroke":"#ffaf02"});
            $(".mr").css({"fill":"#ffaf02"});
            ProgressVoip(data.talking, CurrentProx);
        } else {
            $('.mic').css({"stroke":"#F5F5F5"});
            $(".mr").css({"fill":"#F5F5F5"});
            let data = {'proxmity' : CurrentProx}
            QBHud.UpdateProximity(data)
        }
        
        Progress(data.armor, ".armor");
        if (data.armor >= 6) {
            $('.harmor').fadeIn(3000);
        }
        if (data.armor <= 5) {
            $('.harmor').fadeOut(3000);
        }
         if (data.armor <= 10) {
             $('.amr').css("stroke", "lightblue");
         } else {
             $('.amr').css("stroke", "#248bbe");
         }
        Progress(data.hunger, ".hunger");
        if (data.hunger <= 49) {
            $('.hhunger').fadeIn(3000);
        }
        if (data.hunger >= 50) {
            $('.hhunger').fadeOut(3000);
        }
        if (data.hunger <= 10) {
            $('.fome').css("stroke", "red");
        } else {
            $('.fome').css("stroke", "#f0932b");
        }
        Progress(data.thirst, ".thirst");
        if (data.thirst <= 49) {
            $('.hthirst').fadeIn(3000);
        }
        if (data.thirst >= 50) {
            $('.hthirst').fadeOut(3000);
        }
        if (data.thirst <= 10) {
            $('.cede').css("stroke", "red");
        } else {
            $('.cede').css("stroke", "#3467d4");
        }
        Progress(data.stress, ".stress");
        if (data.stress >= 6) {
            $('.hstress').fadeIn(3000);
        }
        if (data.stress <= 5) {
            $('.hstress').fadeOut(3000);
        }
        Progress(data.nivel, ".nitrous");
        if (data.activo) {
        $(".nitrous").css({"stroke":"#fcb80a"});
        } else {
        $(".nitrous").css({"stroke":"rgb(241, 71, 185)"});
        }  
       
        setProgressSpeed(data.speed, ".progress-speed");
        setProgressFuel(data.fuel, ".progress-fuel");
        //$('fuel').fadeIn(450);
        //Progress(data.fuel.toFixed(0), ".fuel");
        //$("#speed-amount").html(data.speed);

        if (data.seatbelt) {
            $(".car-seatbelt-info img").fadeOut(750);
        } else {
            $(".car-seatbelt-info img").fadeIn(750);
        }

        if (data.talking && data.radio) {
            $(".mic").css({"background-color": "#3467d4"}); 
        } else if (data.talking) {
            $(".mic").css({"background-color": "white"}); 
        } else {
            $(".mic").css({"background-color": "rgb(85, 85, 85)"}); 
        }
    };

    QBHud.UpdateProximity = function(data) {
        let state = 100
        CurrentProx = data.proxmity
        switch(data.proxmity) {
            case 1:
                state = 33
                break;
            case 2:
                state = 66
                break;
            case 3:
                state = 100
                break;
            default:
                state = 100;
                break;
        }
        Progress(state, '.mic')
    }

    QBHud.SetTalkingState = function(data) {
        if (!data.IsTalking) {
            $(".voice-block").animate({"background-color": "rgb(255, 255, 255)"}, 150);
        } else {
            $(".voice-block").animate({"background-color": "#fc4e03"}, 150);
        }
    }

    QBHud.Update = function(data) {
        if(data.type == "cash") {
            $(".money-cash").css("display", "block");
            $("#cash").html(data.cash);
            if (data.minus) {
                $(".money-cash").append('<p class="moneyupdate minus">-<span id="cash-symbol">&dollar;&nbsp;</span><span><span id="minus-changeamount">' + data.amount + '</span></span></p>')
                $(".minus").css("display", "block");
                setTimeout(function() {
                    $(".minus").fadeOut(750, function() {
                        $(".minus").remove();
                        $(".money-cash").fadeOut(750);
                    });
                }, 3500)
            } else {
                $(".money-cash").append('<p class="moneyupdate plus">+<span id="cash-symbol">&dollar;&nbsp;</span><span><span id="plus-changeamount">' + data.amount + '</span></span></p>')
                $(".plus").css("display", "block");
                setTimeout(function() {
                    $(".plus").fadeOut(750, function() {
                        $(".plus").remove();
                        $(".money-cash").fadeOut(750);
                    });
                }, 3500)
            }
        }
    };

    function ProgressVoip(percent, element) {
        //   var circle = document.querySelector(element);
        //   var radius = circle.r.baseVal.value;
        //   var circumference = radius * 200 * Math.PI;
         
          // circle.style.strokeDasharray = `${circumference} ${circumference}`;
       //    circle.style.strokeDashoffset = `${circumference}`;
         
        //   const offset = circumference - ((-percent * 100) / 100 / 100) * circumference;
           //circle.style.strokeDashoffset = -offset;
           
       }

    function Progress(percent, element) {
        var circle = document.querySelector(element);
        var radius = circle.r.baseVal.value;
        var circumference = radius * 2 * Math.PI;
      
        circle.style.strokeDasharray = `${circumference} ${circumference}`;
        circle.style.strokeDashoffset = `${circumference}`;
      
        const offset = circumference - ((-percent * 100) / 100 / 100) * circumference;
        circle.style.strokeDashoffset = -offset;
    }

    function setProgressSpeed(value, element){
        var circle = document.querySelector(element);
        var radius = circle.r.baseVal.value;
        var circumference = radius * 2 * Math.PI;
        var html = $(element).parent().parent().find('span');
        var percent = value*100/450;
    
        circle.style.strokeDasharray = `${circumference} ${circumference}`;
        circle.style.strokeDashoffset = `${circumference}`;
    
        const offset = circumference - ((-percent*73)/100) / 100 * circumference;
        circle.style.strokeDashoffset = -offset;
    
        html.text(value);
      }
      
      function setProgressFuel(percent, element) {
        var circle = document.querySelector(element);
        var radius = circle.r.baseVal.value;
        var circumference = radius * 2 * Math.PI;
        var html = $(element).parent().parent().find("span");
      
        circle.style.strokeDasharray = `${circumference} ${circumference}`;
        circle.style.strokeDashoffset = `${circumference}`;
      
        const offset = circumference - ((-percent * 73) / 100 / 100) * circumference;
        circle.style.strokeDashoffset = -offset;
      
        html.text(Math.round(percent));
      }

    window.onload = function(e) {
        window.addEventListener('message', function(event) {
            switch(event.data.action) {
                case "open":
                    QBHud.Open(event.data);
                    break;
                case "close":
                    QBHud.Close();
                    break;
                case "update":
                    QBHud.Update(event.data);
                    break;
                case "show":
                    QBHud.Show(event.data);
                    break;
                case "hudtick":
                    QBHud.UpdateHud(event.data);
                    break;
                case "car":
                    QBHud.CarHud(event.data);
                    break;
                case "seatbelt":
                    QBHud.ToggleSeatbelt(event.data);
                    break;
                case "nitrous":
                    QBHud.UpdateNitrous(event.data);
                    break;
                    case "UpdateProximity":
                        QBHud.UpdateProximity(event.data);
                    break;
                case "talking":
                    QBHud.SetTalkingState(event.data);
                    break;
            }
        })
    }

})();