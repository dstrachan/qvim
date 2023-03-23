dir:` sv first[` vs hsym .z.f],`vim`syntax
if[not kFile~key kFile:` sv dir,`k.vim;
  exit 1];
if[not qFile~key qFile:` sv dir,`q.vim;
  exit 1];

extraPrimitives:`by`from
extraFuncs:` sv'`.Q,/:`D`P`PD`PV`pd`pf`pn`pv`u`vp`x

getFuncs:{[namespace]
  ` sv'namespace,/:1_key namespace}

kPrimitiveHead:"syn keyword kPrimitive "
kPrimitives:kPrimitiveHead,/:string asc distinct .Q.res,extraPrimitives

qLibHead:"syn keyword qLib "
qLibs:qLibHead,/:ssr[;".";"\\."]@'string asc distinct extraFuncs,raze getFuncs'[` sv'`,/:key`]

qFunctionHead:"syn keyword qFunction "
qFunctions:qFunctionHead,/:string asc distinct 1_key`.q

getContent:{[content;d]
  i:til count content;
  f:first values:value d;
  l:last values;
  head:content f[0]#i;
  middle:content 1_(l[0]-f 1)#f[1]_i;
  tail:content 1_l[1]_i;
  res:head,value[first key d],$[f~l;();middle,value[last key d]],tail;
  res}

// kFile
content:read0 kFile
kPrimIndex:where content like kPrimitiveHead,"*"
qLibIndex:where content like qLibHead,"*"
kFile 0:getContent[content;(min;max)@\:/:asc`kPrimitives`qLibs!(kPrimIndex;qLibIndex)]

// qFile
content:read0 qFile
qFuncIndex:where content like qFunctionHead,"*"
qFile 0:getContent[content;(min;max)@\:/:asc enlist[`qFunctions]!enlist qFuncIndex]
\\
