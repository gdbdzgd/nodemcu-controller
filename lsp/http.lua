--创建一个简易的http服务器，只支持GET
--参数port表示服务器端口，默认值80
--返回一个对象，代表创建的http服务器，包含如下方法：
----map(path,handler)：添加一个映射，path路径的请求交由handler函数处理，
------handler的参数列表为(socket,path,params),分别表示socket，请求路径和参数
----stop()：停止服务器

function newHttpServer(port)
    --tcp监听socket
    local server=0
    --url映射表
    local maps={}

    --按分隔符分割字符串，返回一个数组
    local function split(str,delim)
        local items={}
        local start=1
        while true do
            --查找下一个分隔符
            local pos=string.find(str,delim,start,true)
            --未找到则加入末尾子串，退出
            if not pos then
                table.insert(items,string.sub(str,start))
                break
            end
            --加入分隔符之前的子串
            table.insert(items,string.sub(str,start,pos-1))
            start=pos+string.len(delim)
        end
        return items
    end

    --执行http请求
    local function request(socket,path,params)
        --找到处理函数
        local handler=maps[path]
        if not handler then
            handler=maps["default"]
            if not handler then
                return
            end
        end
        --处理http请求
        handler(socket,path,params)
    end

    --解析一行数据，如果是GET就继续处理
    local function parseGET(socket,line)
        local items=split(line," ")
        --如果是GET请求，那么有“GET <URL> HTTP/1.1”的格式
        if table.getn(items)~=3 or items[1]~="GET" or items[3]~="HTTP/1.1" then
            return
        end
        --按“?”把URL部分拆分成path和paramsStr
        items=split(items[2],"?")
        local path=items[1]
        local paramsStr=items[2]
        --参数key-value集
        local params={}
        --有参数
        if paramsStr then
            --按“&”把参数分开
            items=split(paramsStr,"&")
            --遍历所有参数
            for i,param in pairs(items) do
                --按“=”把键、值分开
                local keyValue=split(param,"=")
                if table.getn(keyValue)~=2 then
                    return
                end
                local key=keyValue[1]
                local value=keyValue[2]
                --加入参数集
                params[key]=value
            end
        end
        --执行请求
        request(socket,path,params)
    end

    --创建tcp监听socket，客户socket超过60s没有响应就断开
    server=net.createServer(net.TCP,60)
    --port默认值为80
    if not port then
        port=80
    end
    --监听port端口
    server:listen(port,function(client)
	    --收到数据的处理函数
        client:on("receive",function(socket,data)
		    --按行分割
            local lines=split(data,"\r\n")
            for i,line in pairs(lines) do
                --去掉换行符，解析GET请求（如果是的话）
                parseGET(socket,string.gsub(line,"%c",""))
            end
        end)
    end)

    --http服务器对象
    local http={}
    --添加映射
    http.map=function(path,handler)
        maps[path]=handler
    end
    --停止服务器
    http.stop=function()
        server:close()
    end
    return http
end
