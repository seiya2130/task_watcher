// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .


function OnButtonClick(){
    var value = document.getElementById('btn').textContent;
    if(value == "カウントダウン表示"){ 
        document.getElementById('btn').textContent = "日付表示";
        recalc();
    }else if(value == "日付表示"){
        document.getElementById('btn').textContent = "カウントダウン表示";
        clearTimeout(timer);
        var count = document.getElementById('count').textContent;
        for(i=0;i<count;i++){
            document.getElementById(i).classList.remove('none')
            document.getElementById('timer'+i).classList.add('none')
        }    
    }

}

function recalc(){
    if(document.getElementById('btn').textContent == "日付表示"){
        var count = document.getElementById('count').textContent;
        for(i=0;i<count;i++){
            document.getElementById(i).classList.add('none')
            document.getElementById('timer'+i).classList.remove('none')
            var tmp = document.getElementById(i).textContent;
            var date = tmp.split("/")
            console.log(date)
            var year = date[0];
            var month = date[1];
            var day = date[2];
            var goal = new Date(year,month-1,day);
            goal.setHours(23);
            goal.setMinutes(59);
            goal.setSeconds(59);        
            var counter = countdown(goal);
            var time = counter[0] + '日' + counter[1] + '時間' + counter[2] + '分' + counter[3] + '秒';
            document.getElementById("timer"+i).textContent = time
        }
    refresh();
    }
}

function countdown(goal){
        var now = new Date();
        var rest = goal.getTime() - now.getTime();
        var sec = Math.floor(rest / 1000 % 60);
        var min = Math.floor(rest / 1000 / 60) % 60;
        var hours = Math.floor(rest / 1000 / 60 / 60) % 24;
        var days = Math.floor(rest / 1000 / 60 / 60 / 24);
        var count = [ days,hours, min, sec];
        return count;
}

function refresh(){
    timer = setTimeout(recalc, 1000);
}