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

  let nodes = dom.childNodes()
  if !len(nodes)
    return dom.toString()
  endif

  let str = "<" . dom.name . ">\n"
  let str = s:format_nodes(nodes , 1 , str)
  let str = str . "</" . dom.name . ">"
  return str
endfunction

function! s:format_nodes(nodes, depth, str)
  let indent = repeat("  " ,  a:depth)
  let str = a:str
  for node in a:nodes
    let str = str . indent . "<" . node.name
    for key in keys(node.attr)
      let str = str . ' ' . key . '="' . node.attr[key] . '"'
    endfor
    let str = str . ">"
    let children = node.childNodes()
    if len(children) == 0
      if len(node.child) != 0
        let str = str . node.child[0]
      endif
    else
      let str = str . "\n"
      let str = s:format_nodes(children , a:depth + 1 , str) . indent
    endif
    let str = str . "</" . node.name . ">\n"
  endfor
  return str
endfunctio
