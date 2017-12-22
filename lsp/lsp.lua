function newLSPHandler()
    --执行lsp脚本
    local function doLSP(script,params)
        --包裹反转
        script="%>"..string.gsub(script,"%c"," ").."<%"
        script=string.gsub(script,"%%>"," echo('")
        script=string.gsub(script,"<%%","') ")
        --参数params
        local paramsStr=" local params=cjson.decode('"..cjson.encode(params).."') "
        --echo()
        local echoStr=" local __echos={} function echo(msg) table.insert(__echos,msg) end "
        --转换后的脚本，返回输出内容
        script=paramsStr..echoStr..script.." return table.concat(__echos) "
        --输出结果
        local result=loadstring(script)()
        return result
    end

    --读取文件内容
    local function readFile(path)
        --去掉开头的/
        path=string.gsub(path,"^/","")
        --无法打开文件
        if not file.open(path,"r") then
            return nil
        end
        --文件内容
        local content=""
        --读出文件所有内容
        while true do
            local part=file.read()
            --读到EOF
            if not part then
                break
            end
            content=content..part
        end
        file.close()
        return content
    end

    --获取文件扩展名
    local function getType(path)
        --最后一个“.”的位置
        local index=string.find(path,"\.[^\.]*$")
        if index==nil then
            return nil
        end
        --获取文件扩展名
        return string.sub(path,index+1)
    end

    --发送http响应报文
    local function output(socket,status,content)
        --状态头
        local response="HTTP/1.1 "..status.."\r\n"
        --Content-Length字段
        response=response.."Content-Length: "..string.len(content).."\r\n"
        --内容
        response=response.."\r\n"..content
        --发送
        socket:send(response)
    end

    --处理lsp和静态文件
    local function handler(socket,path,params)
        --读取文件内容
        local content=readFile(path)
        --如果打开文件失败
        if not content then
            output(socket,"404 Not Found","")
            return
        end
        --如果是lsp脚本，那么执行
        if getType(path)=="lsp" then
            content=doLSP(content,params)
        end
        --输出结果
        output(socket,"200 OK",content)
    end

    return handler
end
