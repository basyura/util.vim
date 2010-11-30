"
" xml util
" 手探り状態
"
function! util#xml#indent_file(file)
  return util#xml#indent(xml#parseFile(a:file))
endfunction

function! util#xml#indent(source)
  " for xml
  if type(a:source) == type("")
    let dom = xml#parse(a:source)
  else
    " for dom object(dict) which parsed with web-api.vim
    let dom = a:source
  endif
  " 子ノードがない場合は toString を使ってそのまま返却
  let nodes = dom.childNodes()
  if !len(nodes)
    return dom.toString()
  endif

  let str  = "<" . dom.name . ">\n"
  let str  = s:format_nodes(nodes , 1 , str)
  let str .= "</" . dom.name . ">"
  return str
endfunction

function! s:format_nodes(nodes, depth, str)
  let indent = repeat("  " ,  a:depth)
  let str = a:str
  for node in a:nodes
    let str .= indent . "<" . node.name
    for key in keys(node.attr)
      let str .= ' ' . key . '="' . node.attr[key] . '"'
    endfor
    let str .= ">"
    let children = node.childNodes()
    if len(children) == 0
      let str = str . node.value()
    else
      let str .= "\n" . s:format_nodes(children , a:depth + 1 , str) . indent
    endif
    let str .= "</" . node.name . ">\n"
  endfor
  return str
endfunction

