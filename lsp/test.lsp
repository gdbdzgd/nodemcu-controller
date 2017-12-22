<%
name=params["name"]
age=params["age"]
if not name or not age then
    return "no name or age given"
end
age=tonumber(age)
%>

<html>
    <head>
        <title>welcome</title>
        <script type="text/javascript" src="/test.js"></script>
        <link rel="stylesheet" type="text/css" href="/test.css"/>
    </head>
    <body>
        Hello, my name is <%echo(name)%>.
        <br>
        <% if age<18 then %>
            <span class="young">I am a teenage.</span>
        <% else %>
            <span class="old">I m an adult.</span>
        <% end %>
        <br>
        <input type="button" value="say welcome" onclick="sayWelcome(\'<%echo(name)%>\')"/>
    </body>
</html>
