"
" xml util
" 手探り状態
"
" kind_of 的なものはないのかな？
"
function! util#xml#indent_text(text)
  return util#xml#indent(xml#parse(a:text))
endfunction

function! util#xml#indent_file(file)
  return util#xml#indent(xml#parseFile("xml.txt"))
endfunction

function! util#xml#indent(dom)
  let str = "<" . a:dom.name . ">\n"
  let str =  s:format_nodes(a:dom.childNodes() , 1 , str)
  let str = str . "</" . a:dom.name . ">"
  return str
endfunction

function! s:format_nodes(nodes, depth, str)
  let indent = repeat("  " ,  a:depth)
  let str = a:str
  for node in a:nodes
    let str = str . indent . "<" . node.name . ">"
    let children = node.childNodes()
    if len(children) == 0
      let str = str . node.child[0]
    else
      let str = str . "\n"
      let str = s:format_nodes(children , a:depth + 1 , str) . indent
    endif
    let str = str . "</" . node.name . ">\n"
  endfor
  return str
endfunction
