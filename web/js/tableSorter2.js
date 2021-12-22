th = document.getElementsByTagName('th');
var Ctable = "";


for(let c = 0; c < th.length; c++) {
    th[c].addEventListener('click', item(c))
}

function item(c){
    return function() {
        if(localStorage.getItem("page")!=null && localStorage.getItem("page")=="history")
        {
            if(c <= 5)
                Ctable = "uncollected";
            else if( c > 5 && c <= 11)
                Ctable = "pending";
            else if( c > 11)
                Ctable = "collected";
        }
        else if(localStorage.getItem("page")!=null && localStorage.getItem("page")=="adminhome")
        {
            if(c <= 10)
                Ctable = "parcel";
        }
        else{
            console.log("ok")
            if(c <= 7)
                Ctable = "uncollected";
            else if(c > 7 && c <= 15)
                Ctable = "pending";
            else if(c > 15)
                Ctable = "collected";
        }
        if(localStorage.getItem("column") == c && localStorage.getItem("order") == "acs")
        {
            sortTableD(c)
            imagesort(c, "a")
        }
        else
        {
            sortTableA(c)
            imagesort(c, "d")
        }
    }
}

function imagesort(c, o) {
    if(o == "a")
        var cn = "highlightcA";
    else
        var cn = "highlightcD";

    for(let a = 0; a < th.length; a++)
    {
        if(a == c)
        {
            document.getElementsByTagName("th")[a].className = cn
        }
        else
        {
            document.getElementsByTagName("th")[a].className = ""
        }
    }
}


function sortTableA(c) {
    var table, rows, switching, i, x, y, shouldSwitch, z;
    if(localStorage.getItem("page") == null)
    {
        if(Ctable == "uncollected")
            z = c;
        else if(Ctable == "pending")
            z = c - 7;
        else
            z = c - 15;
        console.log(z);
    }
    else if(localStorage.getItem("page") == "adminhome")
    {
        z = c;
        console.log(z);
    }
    else
    {
        if(Ctable == "uncollected")
            z = c;
        else if(Ctable == "pending")
            z = c - 6;
        else
            z = c - 12;
        console.log(z);
    }

    table = document.getElementById(Ctable);
    switching = true;
    while (switching) {
        switching = false;
        rows = table.rows;
        for (i = 1; i < (rows.length - 1); i++) {
            shouldSwitch = false;
            x = rows[i].getElementsByTagName("TD")[z];
            y = rows[i + 1].getElementsByTagName("TD")[z];
            if (x.innerHTML.toLowerCase() > y.innerHTML.toLowerCase()) {
                shouldSwitch = true;
                break;
            }
        }
        if (shouldSwitch) {
            rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
            switching = true;
        }
    }
    localStorage.setItem("column", c);
    localStorage.setItem("order", "acs");
}

function sortTableD(c) {
    var table, rows, switching, i, x, y, shouldSwitch, z;
    if(localStorage.getItem("page") == null)
    {
        if(Ctable == "uncollected")
            z = c;
        else if(Ctable == "pending")
            z = c - 7;
        else
            z = c - 15;
        console.log(z);
    }
    else if(localStorage.getItem("page") == "adminhome")
    {
        z = c;
        console.log(z);
    }
    else
    {
        if(Ctable == "uncollected")
            z = c;
        else if(Ctable == "pending")
            z = c - 6;
        else
            z = c - 12;
        console.log(z);
    }
    table = document.getElementById(Ctable);
    switching = true;
    while (switching) {
        switching = false;
        rows = table.rows;
        for (i = 1; i < (rows.length - 1); i++) {
            shouldSwitch = false;
            x = rows[i].getElementsByTagName("TD")[z];
            y = rows[i + 1].getElementsByTagName("TD")[z];
            if (x.innerHTML.toLowerCase() < y.innerHTML.toLowerCase()) {
                shouldSwitch = true;
                break;
            }
        }
        if (shouldSwitch) {
            rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
            switching = true;
        }
    }
    localStorage.setItem("column", c);
    localStorage.setItem("order", "desc");
}