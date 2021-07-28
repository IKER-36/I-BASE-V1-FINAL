var players = null

function getValue(id) {
    var value = $("#" + id).val();
    return value
}

function ChangeSelected(new_id) {
    var actual_selected = document.getElementsByClassName("nav-item active")[0];
    actual_selected.className = "nav-item";

    var new_select = document.getElementById(new_id);
    new_select.className = "nav-item active";

    return true;

}

function sendMessage(msg) {
    $.post("https://kc_admin/msg", JSON.stringify({"msg" : msg}))
}

function cleanTextarea() {
    document.getElementById("reason_textarea").value = "";
}

function removeRow(table_id) {
    removeWarn(table_id);
}

function fixTable(table_id, warn_id) {

    var table = document.getElementById("warn_" + table_id);
    table.id = "warn_" + warn_id;
    table.childNodes[3].innerHTML = '<button id="warn_delete" type="button" onclick="removeWarn(' + "'" + warn_id + "'" + ')" class="btn btn-danger">Eliminar</button>';

}

function Notify(type, title, text) {

    var id = Math.floor(Math.random() * 10001);

    while (true) {
        var ntfy = document.getElementById(id);

        if(ntfy) {
            id = Math.floor(Math.random() * 10001);
        } else {
            break
        }
    }

    var id = id.toString();

    var notify = document.createElement("div");
    notify.id = id;

    notify.className = "alert alert-dismissible alert-" + type;

    var button = document.createElement("button");
    button.className = "close";
    button.type = "button";
    button.setAttribute("data-dismiss", "alert");
    button.innerHTML = "&times;";

    var title_ = document.createElement("strong")
    title_.innerText = title;

    var text_ = document.createElement("p");
    text_.innerText = text;

    notify.appendChild(button);
    notify.appendChild(title_);
    notify.appendChild(text_);

    document.getElementById("notify_container").appendChild(notify);

    $("#" + id).fadeOut(3000)

}

function banSomeone(id, reason) {

    if (reason.replace(" ", "") == "") {
        reason = "Unspecified reason";
    }

    var player_selected = document.getElementsByClassName("player selected")[0]
    player_selected.remove()
    Clear()

    $.post("https://kc_admin/ban", JSON.stringify({"id" : id, "reason" : reason}))

}

function kickSomeone(id, reason) {

    if (reason.replace(" ", "") == "") {
        reason = "Unspecified reason";
    }

    var player_selected = document.getElementsByClassName("player selected")[0]
    player_selected.remove()
    Clear()

    $.post("https://kc_admin/kick", JSON.stringify({"id" : id, "reason" : reason}))

}

function warnSomeone(id, reason) {

    if (reason.replace(" ", "") == "") {
        reason = "Unspecified reason"
    }

    if (reason.length > 250) {
        Notify("danger", "Warn not sent", "The warn reason length have a limit of 250 chars");
        return;
    }

    var table_id = Math.floor(Math.random() * 10001);

    while (true) {
        var table = document.getElementById(table_id);

        if(table) {
            table_id = Math.floor(Math.random() * 10001);
        } else {
            break
        }
    }

    table_id = table_id.toString();

    var date = Math.floor(new Date().getTime() / 1000);

    var tbody = document.getElementsByTagName("tbody")[0];
    var tr = document.createElement("tr");
    tr.className = "table-ligth";
    tr.id = "warn_" + table_id;

    var th_date = document.createElement("th");
    var th_reason = document.createElement("th");
    var th_admin = document.createElement("th");
    var th_button = document.createElement("th");

    th_date.className = "warn table_time";
    th_reason.className = "warn table_reason";
    th_admin.className = "warn table_admin";
    th_button.className = "warn table_button";

    tr.appendChild(th_date);
    tr.appendChild(th_reason);
    tr.appendChild(th_admin);
    tr.appendChild(th_button);

    th_date.innerText = timeConverter(date);
    th_reason.innerText = reason;
    th_admin.innerText = "Tu";
    th_button.innerText = "En proceso...";

    tbody.appendChild(tr);

    var warn_n = document.getElementById("warn_n").innerText;
    var n = warn_n.split(":")[1]
    n = parseInt(n);
    n += 1

    if (n <= 1) {
        document.getElementById("warn_n").innerHTML = "Warns Totales: " + Badge("success", n);
    }
    else if (n == 2) {
        document.getElementById("warn_n").innerHTML = "Warns Totales: " + Badge("warning", n);
    }
    else if (n >= 3) {
        document.getElementById("warn_n").innerHTML = "Warns Totales: " + Badge("danger", n);
    }

    $.post("https://kc_admin/warn", JSON.stringify({"id" : id, "reason" : reason, "table_id" : table_id, "date" : date.toString()}))

}

function removeWarn(id) {

    var row = document.getElementById("warn_" + id)
    row.remove();

    var warn_n = document.getElementById("warn_n").innerText;
    var n = warn_n.split(":")[1]
    n = parseInt(n);
    n -= 1

    if (n <= 1) {
        document.getElementById("warn_n").innerHTML = "Warns Totales: " + Badge("success", n);
    }
    else if (n == 2) {
        document.getElementById("warn_n").innerHTML = "Warns Totales: " + Badge("warning", n);
    }
    else if (n >= 3) {
        document.getElementById("warn_n").innerHTML = "Warns Totales: " + Badge("danger", n);
    }

    $.post("https://kc_admin/remove_warn", JSON.stringify({"id" : id}))

}

function ClearAll() {
    $("#warn_n").empty()
    $("#warn_menu").empty()
    $("#warn_menu").css("display", "none")
    $("#apply_menu").empty()
    $("#list").empty()
    $("#list").css("display", "none")
    $("#bans_menu").css("display", "none")
    $("#button_container").empty()
    $("#bans_menu").empty();
}

function Clear() {
    $("#warn_n").empty()
    $("#warn_menu").empty()
    $("#warn_menu").css("display", "none")
    $("#apply_menu").empty()
}

function Badge(type, n) {
    return '<span class="badge badge-' + type + '">' + n + '</span>';
}

function timeConverter(UNIX_timestamp) {
    var a = new Date(UNIX_timestamp * 1000);
    var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    var year = a.getFullYear();
    var month = months[a.getMonth()];
    var date = a.getDate();
    var hour = a.getHours();
    var min = a.getMinutes();
    var sec = a.getSeconds();
    var time = date + ' ' + month + ' ' + year + ' ' + hour + ':' + min + ':' + sec ;
    return time;
}

function addWarns(warn_data) {

    warn_data = JSON.parse(warn_data);
    var tbody = document.getElementsByTagName("tbody")[0]

    if (warn_data == null) {
        warn_data = [];
    }

    if (warn_data == undefined) {
        document.getElementById("warn_n").innerHTML = "Warns Totales: " + Badge("success", 0);
        return;
    }

    if (warn_data.length <= 1) {
        document.getElementById("warn_n").innerHTML = "Warns Totales: " + Badge("success", warn_data.length);
    }
    else if (warn_data.length == 2) {
        document.getElementById("warn_n").innerHTML = "Warns Totales: " + Badge("warning", warn_data.length);
    }
    else if (warn_data.length >= 3) {
        document.getElementById("warn_n").innerHTML = "Warns Totales: " + Badge("danger", warn_data.length);
    }

    for (let i in warn_data) {
        var warn = warn_data[i];
        
        var id = warn.id;
        var reason = warn.reason;
        var admin = warn.admin_name;
        var time = timeConverter(warn.timestamp);

        var inputs = [time, reason, admin, '<button id="warn_delete" type="button" onclick="removeWarn(' + "'" + id + "'" + ')" class="btn btn-danger">Eliminar</button>'];
        var inputs_css = ["table_time", "table_reason", "table_admin", "table_button"];

        var tr = document.createElement("tr");
        tr.id = "warn_" + id;
        tr.className = "table-light";

        for (let i in inputs) {

            var th = document.createElement("th");
            th.innerHTML = inputs[i];
            th.className = "warn " + inputs_css[i];
            tr.append(th);

        }

        tbody.appendChild(tr);

    }
}

function removeBan(id) {

    var row = document.getElementById("ban_" + id);
    row.remove()

    $.post("https://kc_admin/remove_ban", JSON.stringify({"id" : id}));
}

function addBans(ban_data) {

    ban_data = JSON.parse(ban_data);
    var tbody = document.getElementsByTagName("tbody")[0]

    for (let i in ban_data) {
        var ban = ban_data[i];

        var id = ban.id;
        var name = ban.name;
        var reason = ban.reason;
        var admin_name = ban.admin_name;
        var time = ban.time;
        var date = timeConverter(ban.date); 

        if (time != "permanent") {
            time = timeConverter(time)
        } else {
            time = "Nunca";
        }

        var inputs = [name, reason, admin_name, time, date, '<button id="ban_delete" type="button" align="left" onclick="removeBan(' + "'" + id + "'" + ')" class="btn btn-danger">Eliminar</button>'];
        var inputs_css = ["ban_table_admin", "ban_table_reason", "ban_table_admin", "ban_table_time", "ban_table_time", ""];

        var tr = document.createElement("tr");
        tr.className = "table-light limit";
        tr.id = "ban_" + id;

        for (let i in inputs) {

            var th = document.createElement("th");
            th.innerHTML = inputs[i];
            th.className = "ban " + inputs_css[i];
            tr.append(th);

        }

        tbody.appendChild(tr);

    }

}

function Client() {

    document.getElementById("warn_n").innerHTML = "Warns Totales: " + Badge("info", "Loading...");

    $("#warn_menu").empty()

    var container = document.getElementById("warn_menu");

    var rows = ["Fecha", "Razon", "Sancionador", ""];

    var table = document.createElement("table");
    table.className = "table table-hover warn_table";

    var thead = document.createElement("thead");
    var thead_tr = document.createElement("tr");

    for (let i in rows) {
        var thead_th = document.createElement("th");
        thead_th.innerText = rows[i];
        thead_tr.appendChild(thead_th);
    }

    thead.appendChild(thead_tr);
    var tbody = document.createElement("tbody");

    table.appendChild(thead);
    table.appendChild(tbody);

    container.appendChild(table);

    var container = document.getElementById("apply_menu");

    var textarea = document.createElement("textarea")
    textarea.id = "reason_textarea";
    textarea.className = "form-control";
    textarea.placeholder = "Información del baneo/warn/kick"
    textarea.rows = 3;

    container.appendChild(textarea);

    var warn_button = document.createElement("button");
    var kick_button = document.createElement("button");
    var ban_button = document.createElement("button");
    var bring_button = document.createElement("button");
    var goto_button = document.createElement("button");
    var return_button = document.createElement("button");
    var noclip_button = document.createElement("button");
    var visibility_button = document.createElement("button");
    var slay_button = document.createElement("button");
    var revive_button = document.createElement("button");
    var freeze_button = document.createElement("button");
    var jail_input = document.createElement("input");
    var jail_button = document.createElement("button");
    var unjail_button = document.createElement("button");
    var money_amount = document.createElement("input");
    var money_select = document.createElement("select");
    var money_button = document.createElement("button");
    var job_name = document.createElement("input");
    var job_grade = document.createElement("select");
    var job_button = document.createElement("button");
    var group_select = document.createElement("select");
    var group_button = document.createElement("button");

    warn_button.id = "warn_button";
    warn_button.className = "btn btn-warning";
    warn_button.innerText = "Warn";
    warn_button.onclick = function() {

        var player_id = document.getElementsByClassName("player selected")[0].id.split("_")[1];
        var reason = $("textarea#reason_textarea").val();

        warnSomeone(player_id, reason);
        cleanTextarea();
    }

    kick_button.id = "kick_button";
    kick_button.className = "btn btn-info";
    kick_button.innerText = "Kick";
    kick_button.onclick = function() {

        var player_id = document.getElementsByClassName("player selected")[0].id.split("_")[1];
        var reason = $("textarea#reason_textarea").val();

        kickSomeone(player_id, reason);

    }

    ban_button.id = "ban_button";
    ban_button.className = "btn btn-danger";
    ban_button.innerText = "Ban";
    ban_button.onclick = function() {

        var player_id = document.getElementsByClassName("player selected")[0].id.split("_")[1];
        var reason = $("textarea#reason_textarea").val();

        banSomeone(player_id, reason);

    }

    bring_button.id = "bring_button";
    bring_button.className = "btn btn-secondary";
    bring_button.innerText = "Traer";
    bring_button.onclick = function() {
        var player_id = document.getElementsByClassName("player selected")[0].id.split("_")[1];

        $.post("https://kc_admin/bring", JSON.stringify({"id" : player_id}))
    }

    goto_button.id = "goto_button";
    goto_button.className = "btn btn-secondary";
    goto_button.innerText = "Ir";
    goto_button.onclick = function() {
        var player_id = document.getElementsByClassName("player selected")[0].id.split("_")[1];

        $.post("https://kc_admin/goto", JSON.stringify({"id" : player_id}))

    }

    return_button.id = "return_button";
    return_button.className = "btn btn-secondary";
    return_button.innerText = "Devolver";
    return_button.onclick = function() {
        var player_id = document.getElementsByClassName("player selected")[0].id.split("_")[1];

        $.post("https://kc_admin/return", JSON.stringify({"id" : player_id}))

    }


    noclip_button.id = "noclip_button";
    noclip_button.className = "btn btn-secondary";
    noclip_button.innerText = "Noclip";
    noclip_button.onclick = function() {
        var player_id = document.getElementsByClassName("player selected")[0].id.split("_")[1];

        $.post("https://kc_admin/noclip", JSON.stringify({"id" : player_id}))

    }

    visibility_button.id = "visibility_button";
    visibility_button.className = "btn btn-secondary";
    visibility_button.innerText = "Invisibilidad";
    visibility_button.onclick = function() {
        var player_id = document.getElementsByClassName("player selected")[0].id.split("_")[1];

        $.post("https://kc_admin/visibility", JSON.stringify({"id" : player_id}))
    }

    slay_button.id = "slay_button";
    slay_button.className = "btn btn-secondary";
    slay_button.innerText  = "Matar";
    slay_button.onclick = function () {
        var player_id = document.getElementsByClassName("player selected")[0].id.split("_")[1];

        $.post("https://kc_admin/slay", JSON.stringify({"id" : player_id}))
    }

    revive_button.id = "revive_button";
    revive_button.className = "btn btn-secondary";
    revive_button.innerText = "Revive";
    revive_button.onclick = function () {
        var player_id = document.getElementsByClassName("player selected")[0].id.split("_")[1];

        $.post("https://kc_admin/revive", JSON.stringify({"id" : player_id}))
    }

    freeze_button.id = "freeze_button";
    freeze_button.className = "btn btn-secondary";
    freeze_button.innerText = "Congelar";
    freeze_button.onclick = function () {
        var player_id = document.getElementsByClassName("player selected")[0].id.split("_")[1];

        $.post("https://kc_admin/freeze", JSON.stringify({"id" : player_id}))
    }

    jail_input.id = "jail_input";
    jail_input.className = "form-control";
    jail_input.placeholder = "Tiempo";

    jail_button.id = "jail_button";
    jail_button.className = "btn btn-secondary";
    jail_button.innerText = "Jail";
    jail_button.onclick = function () {
        var player_id = document.getElementsByClassName("player selected")[0].id.split("_")[1];
        var time = getValue("jail_input");

        var time_n = parseInt(time);

        if (isNaN(time_n)) {
            Notify("danger", "Error", "Time must be a number not '" + time_n + "'");
            return;
        }

        $.post("https://kc_admin/jail", JSON.stringify({"id" : player_id, "time" : time_n}))
    }

    unjail_button.id = "unjail_button";
    unjail_button.className = "btn btn-secondary";
    unjail_button.innerText = "UnJail";
    unjail_button.onclick = function () {
        var player_id = document.getElementsByClassName("player selected")[0].id.split("_")[1];

        $.post("https://kc_admin/unjail", JSON.stringify({"id" : player_id}))
    }

    money_amount.id = "money_amount";
    money_amount.className = "form-control";
    money_amount.type = "text";
    money_amount.placeholder = "1000";

    money_select.id = "money_select";
    money_select.className = "form-control";
    
    var money_types = [["Cartera", "cash"], [ "Banco", "bank"], ["Negro", "black_money"]];
    
    for (let type in money_types) {
        var html = money_types[type][0];
        var value = money_types[type][1];

        var option_tmp = document.createElement("option");
        option_tmp.innerHTML = html;
        option_tmp.value = value;

        money_select.appendChild(option_tmp);
    }

    money_button.id = "money_button";
    money_button.className = "btn btn-success";
    money_button.innerText = "Set";
    money_button.onclick = function () {
        var player_id = document.getElementsByClassName("player selected")[0].id.split("_")[1];
        var amount = getValue("money_amount");
        var money_type = getValue("money_select");

        var amount_n = parseInt(amount);

        if (isNaN(amount_n)) {
            Notify("danger", "Error", "Money must be a number not '" + amount + "'");
            return;
        }

        $.post("https://kc_admin/set_money", JSON.stringify({"id" : player_id, "amount" : amount_n, "money_type" : money_type}))
    }

    job_name.id = "job_name";
    job_name.className = "form-control";
    job_name.type = "text";
    job_name.placeholder = "trabajo";

    job_grade.id = "job_grade";
    job_grade.className = "form-control";
    
    var grades = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];

    for (let grade in grades) {
        var option_tmp = document.createElement("option");

        option_tmp.innerText = grades[grade];
        option_tmp.value = parseInt(grades[grade]);

        job_grade.appendChild(option_tmp);
    }

    job_button.id = "job_button";
    job_button.className = "btn btn-success";
    job_button.innerText = "Set";
    job_button.onclick = function () {
        var player_id = document.getElementsByClassName("player selected")[0].id.split("_")[1];
        var job_name = getValue("job_name");
        var job_grade = getValue("job_grade");

        var job_grade_n = parseInt(job_grade);

        $.post("https://kc_admin/set_job", JSON.stringify({"id" : player_id, "job_name" : job_name, "job_grade" : job_grade_n}))
    }

    group_select.id = "group_select";
    group_select.className ="form-control";

    var groups = ["user", "mod", "admin"];

    for (let group in groups) {
        var option_tmp = document.createElement("option");
        option_tmp.innerText = groups[group];
        option_tmp.value = groups[group];
        group_select.appendChild(option_tmp);
    }

    group_button.id = "group_button";
    group_button.className = "btn btn-success";
    group_button.innerText = "Set";
    group_button.onclick = function () {
        var player_id = document.getElementsByClassName("player selected")[0].id.split("_")[1];
        var group = getValue("group_select");

        $.post("https://kc_admin/set_group", JSON.stringify({"id" : player_id, "group" : group}))
    }

    container.appendChild(warn_button);
    container.appendChild(kick_button);
    container.appendChild(ban_button);
    container.appendChild(bring_button);
    container.appendChild(goto_button);
    container.appendChild(return_button);
    container.appendChild(noclip_button);
    container.appendChild(visibility_button);
    container.appendChild(slay_button);
    container.appendChild(revive_button);
    container.appendChild(freeze_button);
    container.appendChild(jail_input);
    container.appendChild(jail_button);
    container.appendChild(unjail_button);
    container.appendChild(money_amount);
    container.appendChild(money_select);
    container.appendChild(money_button);
    container.appendChild(job_name);
    container.appendChild(job_grade);
    container.appendChild(job_button);
    container.appendChild(group_select);
    container.appendChild(group_button);

    return true;
}

function Clients(json_data) {
    ChangeSelected("client_li");

    ClearAll();

    $("#list").css("display", "block")

    $("#list").empty()
    for (let i in json_data) {
        var player = json_data[i];
        $("#list").append("<div class='player' id='player_" + player.id + "'> " + player.id + " | " + player.name + "</div>")
    }

    $(".close").click(function() {

        $(this).parent().fadeOut(1000);
        
    })

    $(".player").click(function () {
        var id_html = $(this).attr("id");
        id = parseInt(id_html.split("_")[1]);

        $(".player").removeClass("selected")
        $(this).addClass("selected")

        $("#warn_menu").css("display", "block")

        Client();

        $.post("https://kc_admin/request_warns", JSON.stringify({"id" : id.toString()}))
    
    })

}

function ServerF() {
    ClearAll();

    ChangeSelected("server_li");
    $("#bans_menu").css("display", "block")

    var container = document.getElementById("button_container");

    var bring_all = document.createElement("button");
    var slay_all = document.createElement("button");
    var revive_all = document.createElement("button");
    var freeze_all = document.createElement("button");
    var get_bans = document.createElement("button");
    var days = document.createElement("input");
    var name = document.createElement("input");

    bring_all.id = "bring_all";
    bring_all.className = "btn btn-secondary";
    bring_all.innerText = "Bring masivo";
    bring_all.onclick = function () {
        $.post("https://kc_admin/bring_all", JSON.stringify({}))
    }

    slay_all.id = "slay_all";
    slay_all.className = "btn btn-secondary";
    slay_all.innerText = "Slay masivo";
    slay_all.onclick = function () {
        $.post("https://kc_admin/slay_all", JSON.stringify({}))
    }

    revive_all.id = "revive_all";
    revive_all.className = "btn btn-secondary";
    revive_all.innerText = "Revive masivo";
    revive_all.onclick = function () {
        $.post("https://kc_admin/revive_all", JSON.stringify({}))
    }

    freeze_all.id = "freeze_all";
    freeze_all.className = "btn btn-secondary";
    freeze_all.innerText = "Freeze masivo";
    freeze_all.onclick = function () {
        $.post("https://kc_admin/freeze_all", JSON.stringify({}))
    }

    get_bans.id = "get_bans";
    get_bans.className = "btn btn-success";
    get_bans.innerText = "Buscar";
    get_bans.onclick = function () {
        var ban_days = getValue("bans_days");
        var ban_name = getValue("name_ban");

        $.post("https://kc_admin/get_bans", JSON.stringify({"days" : ban_days, "name" : ban_name}))
    }

    days.id = "bans_days";
    days.className = "form-control";
    days.placeholder = "Dias"

    name.id = "name_ban";
    name.className = "form-control";
    name.placeholder = "Nombre";

    container.appendChild(bring_all);
    container.appendChild(slay_all);
    container.appendChild(revive_all);
    container.appendChild(freeze_all);
    container.appendChild(get_bans);
    container.appendChild(days);
    container.appendChild(name);

    var container = document.getElementById("bans_menu");

    var rows = ["Usuario", "Razon", "Sancionador", "Fecha de expiracion", "Fecha de aplicacion", ""];

    var table = document.createElement("table");
    table.className = "table table-hover ban_table";

    var thead = document.createElement("thead");
    var thead_tr = document.createElement("tr");

    for (let i in rows) {
        var thead_th = document.createElement("th");
        thead_th.innerText = rows[i];
        thead_tr.appendChild(thead_th);
    }

    thead.appendChild(thead_tr);
    var tbody = document.createElement("tbody");

    table.appendChild(thead);
    table.appendChild(tbody);


    container.appendChild(table);

    return null;
}

$(function() {
    $(document).keyup(function(e) {
        if (e.key == "Escape") {
            $.post("https://kc_admin/close", JSON.stringify({}));
            Clear();
        }
    })
    window.addEventListener("message", function(event) {
        if (event.data.type == "close") {
            $("#admin").css("display", "none")
            Clear();
        }
        else if (event.data.type == "open") {
            $("#admin").css("display", "block")
            players = event.data.players;
            Clients(players);
        }
        else if (event.data.type == "notify") {
            Notify(event.data.type_notify, event.data.title, event.data.text);
        }
        else if (event.data.type == "fix_table") {
            fixTable(event.data.table, event.data.warn);
        }
        else if (event.data.type == "remove_row") {
            removeRow(event.data.table)
        } 
        else if (event.data.type == "add_warns") {
            var warns = event.data.warns;
            var player_id = event.data.id;
            var selected_player_id = document.getElementsByClassName("player selected")[0].id.split("_")[1];

            if (selected_player_id != player_id) {
                Notify("danger", "Error", "You received data but is not for the player selected");
            } else {
                addWarns(warns);
            }

        }
        else if (event.data.type == "add_bans") {
            var bans = event.data.bans;
            addBans(bans);
        }
    })
    $("#close").click(() => {
        $.post("https://kc_admin/close", JSON.stringify({}));
    })
    $("#clients").click(function () {
        ClearAll();
        Clients(players);
    })
    $("#server").click(function () {
        ClearAll();
        ServerF();
    })
})