function run(){
            var top = parseInt($(".inner").css("top").replace("px",""));
            var height = $(".outer").outerHeight();
            height=height*-1;
            if(top >  height)
            {
               $(".inner").animate({"top":height},8000,run)           
            }
            else
            {
                $(".inner").css({"top":-height});
                run();
            }

        }
        run();