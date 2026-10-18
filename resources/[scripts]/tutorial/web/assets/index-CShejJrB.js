import{r as e,a as t,R as r,u as n,b as o,c as i,N as a,H as s}from"./react-vendor-B5GuaGBr.js";import{i as c,c as l,a as u,u as d,f as p,C as f,b as h}from"./utils-vendor-BGIUOQLr.js";!function(){const e=document.createElement("link").relList;if(!(e&&e.supports&&e.supports("modulepreload"))){for(const e of document.querySelectorAll('link[rel="modulepreload"]'))t(e);new MutationObserver(e=>{for(const r of e)if("childList"===r.type)for(const e of r.addedNodes)"LINK"===e.tagName&&"modulepreload"===e.rel&&t(e)}).observe(document,{childList:!0,subtree:!0})}function t(e){if(e.ep)return;e.ep=!0;const t=function(e){const t={};return e.integrity&&(t.integrity=e.integrity),e.referrerPolicy&&(t.referrerPolicy=e.referrerPolicy),"use-credentials"===e.crossOrigin?t.credentials="include":"anonymous"===e.crossOrigin?t.credentials="omit":t.credentials="same-origin",t}(e);fetch(e.href,t)}}();var m={exports:{}},g={},v=e,y=Symbol.for("react.element"),x=Symbol.for("react.fragment"),b=Object.prototype.hasOwnProperty,w=v.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED.ReactCurrentOwner,j={key:!0,ref:!0,__self:!0,__source:!0};function k(e,t,r){var n,o={},i=null,a=null;for(n in void 0!==r&&(i=""+r),void 0!==t.key&&(i=""+t.key),void 0!==t.ref&&(a=t.ref),t)b.call(t,n)&&!j.hasOwnProperty(n)&&(o[n]=t[n]);if(e&&e.defaultProps)for(n in t=e.defaultProps)void 0===o[n]&&(o[n]=t[n]);return{$$typeof:y,type:e,key:i,ref:a,props:o,_owner:w.current}}g.Fragment=x,g.jsx=k,g.jsxs=k,m.exports=g;var S=m.exports,C={},_=t;C.createRoot=_.createRoot,C.hydrateRoot=_.hydrateRoot;const A=e.createContext({}),E=e.createContext({transformPagePoint:e=>e,isStatic:!1,reducedMotion:"never"}),I=e.createContext(null);function P(t){const r=e.useRef(null);return null===r.current&&(r.current=t()),r.current}const R=c?e.useLayoutEffect:e.useEffect,z=()=>!window.invokeNative,$=window.GetParentResourceName?window.GetParentResourceName():"zs-boilerplate";async function D({path:e,payload:t,delay:r,mockData:n}){const o=z();if(o&&n)return r&&await(e=>new Promise(t=>{setTimeout(()=>{t(!0)},e)}))(r),n;try{const i=await fetch(`https://${$}/${e}`,{method:"post",headers:{"Content-Type":"application/json; charset=UTF-8"},body:JSON.stringify(t)}),_txt=await i.text();return _txt?JSON.parse(_txt):{}}catch(_e){return{}}}const M=l()((e,t)=>({visible:z(),canCloseUi:!0,setVisible:t=>e({visible:t}),setCanCloseUi:t=>e({canCloseUi:t}),fetchHideFrame:async()=>{const{visible:r}=t();if(!r)return;await D({path:"hideFrame",mockData:!0})&&e({visible:!1})}}));class F extends e.Component{getSnapshotBeforeUpdate(e){const t=this.props.childRef.current;if(t&&e.isPresent&&!this.props.isPresent){const e=t.offsetParent,r=u(e)&&e.offsetWidth||0,n=this.props.sizeRef.current;n.height=t.offsetHeight||0,n.width=t.offsetWidth||0,n.top=t.offsetTop,n.left=t.offsetLeft,n.right=r-n.width-n.left}return null}componentDidUpdate(){}render(){return this.props.children}}function N({children:t,isPresent:r,anchorX:n,root:o}){const i=e.useId(),a=e.useRef(null),s=e.useRef({width:0,height:0,top:0,left:0,right:0}),{nonce:c}=e.useContext(E);return e.useInsertionEffect(()=>{const{width:e,height:t,top:l,left:u,right:d}=s.current;if(r||!a.current||!e||!t)return;const p="left"===n?`left: ${u}`:`right: ${d}`;a.current.dataset.motionPopId=i;const f=document.createElement("style");c&&(f.nonce=c);const h=o??document.head;return h.appendChild(f),f.sheet&&f.sheet.insertRule(`\n          [data-motion-pop-id="${i}"] {\n            position: absolute !important;\n            width: ${e}px !important;\n            height: ${t}px !important;\n            ${p}px !important;\n            top: ${l}px !important;\n          }\n        `),()=>{h.contains(f)&&h.removeChild(f)}},[r]),S.jsx(F,{isPresent:r,childRef:a,sizeRef:s,children:e.cloneElement(t,{ref:a})})}const L=({children:t,initial:r,isPresent:n,onExitComplete:o,custom:i,presenceAffectsLayout:a,mode:s,anchorX:c,root:l})=>{const u=P(T),d=e.useId();let p=!0,f=e.useMemo(()=>(p=!1,{id:d,initial:r,isPresent:n,custom:i,onExitComplete:e=>{u.set(e,!0);for(const t of u.values())if(!t)return;o&&o()},register:e=>(u.set(e,!1),()=>u.delete(e))}),[n,u,o]);return a&&p&&(f={...f}),e.useMemo(()=>{u.forEach((e,t)=>u.set(t,!1))},[n]),e.useEffect(()=>{!n&&!u.size&&o&&o()},[n]),"popLayout"===s&&(t=S.jsx(N,{isPresent:n,anchorX:c,root:l,children:t})),S.jsx(I.Provider,{value:f,children:t})};function T(){return new Map}const O=e=>e.key||"";function B(t){const r=[];return e.Children.forEach(t,t=>{e.isValidElement(t)&&r.push(t)}),r}const W=({children:t,custom:r,initial:n=!0,onExitComplete:o,presenceAffectsLayout:i=!0,mode:a="sync",propagate:s=!1,anchorX:c="left",root:l})=>{const[u,d]=function(t=!0){const r=e.useContext(I);if(null===r)return[!0,null];const{isPresent:n,onExitComplete:o,register:i}=r,a=e.useId();e.useEffect(()=>{if(t)return i(a)},[t]);const s=e.useCallback(()=>t&&o&&o(a),[a,o,t]);return!n&&o?[!1,s]:[!0]}(s),p=e.useMemo(()=>B(t),[t]),f=s&&!u?[]:p.map(O),h=e.useRef(!0),m=e.useRef(p),g=P(()=>new Map),[v,y]=e.useState(p),[x,b]=e.useState(p);R(()=>{h.current=!1,m.current=p;for(let e=0;e<x.length;e++){const t=O(x[e]);f.includes(t)?g.delete(t):!0!==g.get(t)&&g.set(t,!1)}},[x,f.length,f.join("-")]);const w=[];if(p!==v){let e=[...p];for(let t=0;t<x.length;t++){const r=x[t],n=O(r);f.includes(n)||(e.splice(t,0,r),w.push(r))}return"wait"===a&&w.length&&(e=w),b(B(e)),y(p),null}const{forceRender:j}=e.useContext(A);return S.jsx(S.Fragment,{children:x.map(e=>{const t=O(e),v=!(s&&!u)&&(p===x||f.includes(t));return S.jsx(L,{isPresent:v,initial:!(h.current&&!n)&&void 0,custom:r,presenceAffectsLayout:i,mode:a,root:l,onExitComplete:v?void 0:()=>{if(!g.has(t))return;g.set(t,!0);let e=!0;g.forEach(t=>{t||(e=!1)}),e&&(null==j||j(),b(m.current),s&&(null==d||d()),o&&o())},anchorX:c,children:e},t)})})};function H(t,r){e.useEffect(()=>{const e=e=>{const{action:n,data:o}=e.data;n===t&&r(o)};return z()||window.addEventListener("message",e),()=>{z()||window.removeEventListener("message",e)}},[t,r])}function G({children:e}){const{visible:t,setVisible:r}=M(e=>e);return H("setVisible",async e=>{r(e)}),S.jsx(W,{children:t&&e})}const V=e=>S.jsx("svg",{xmlns:"http://www.w3.org/2000/svg",width:"32",height:"32",fill:"none",viewBox:"0 0 32 32",...e,children:S.jsx("path",{fill:"#A7F1FA",d:"M16 2.667a5 5 0 0 0-4.981 4.565 10.67 10.67 0 0 0-5.686 9.435v2h21.334v-2a10.67 10.67 0 0 0-5.686-9.435A5 5 0 0 0 16 2.667m10.667 18.285h-14V23a1 1 0 0 1-2 0v-2.048H5.333V25a4.334 4.334 0 0 0 4.334 4.333h12.666A4.334 4.334 0 0 0 26.667 25zM16 6c-.93 0-1.832.12-2.693.343a3 3 0 0 1 5.386 0A10.7 10.7 0 0 0 16 6m-5.333 7.89a3.22 3.22 0 0 1 3.222-3.223h4.222a3.223 3.223 0 0 1 3.222 3.222c0 1.164-.945 2.111-2.11 2.111h-6.446a2.11 2.11 0 0 1-2.11-2.11m3.222-1.223a1.223 1.223 0 0 0-1.222 1.222c0 .062.049.111.11.111h6.446a.11.11 0 0 0 .11-.11 1.223 1.223 0 0 0-1.222-1.223z"})}),U=e=>S.jsx("svg",{xmlns:"http://www.w3.org/2000/svg",width:"32",height:"32",fill:"none",viewBox:"0 0 32 32",...e,children:S.jsx("path",{fill:"#A7F1FA",d:"m23.552 13-.27-.096-2.27-4.256A5 5 0 0 0 16.6 6h-5.716A5 5 0 0 0 6.14 9.42l-1.082 3.246A5 5 0 0 0 2 17.274V19.5c0 1.42.846 2.64 2.06 3.19a4 4 0 0 0 7.814.31h8.252a4 4 0 0 0 7.814-.31A3.5 3.5 0 0 0 30 19.5v-.678a5 5 0 0 0-3.324-4.71l-3.02-1.074V13zM8.034 10.052A3 3 0 0 1 10.884 8H13v5H7.054zM21.066 13H15V8h1.6a3 3 0 0 1 2.648 1.588zM6 22a2 2 0 1 1 4 0 2 2 0 0 1-4 0m18-2a2 2 0 1 1 0 4 2 2 0 0 1 0-4"})}),Y=e=>S.jsxs("svg",{xmlns:"http://www.w3.org/2000/svg",width:"24",height:"28",fill:"none",viewBox:"0 0 24 28",...e,children:[S.jsx("path",{fill:"#A7F1FA",fillRule:"evenodd",d:"M7.344 19.646C3.029 20.252 0 21.675 0 23.333c0 2.21 5.373 4 12 4s12-1.79 12-4c0-1.658-3.029-3.081-7.344-3.687a4.667 4.667 0 0 1-9.312 0",clipRule:"evenodd",opacity:"0.4"}),S.jsx("path",{fill:"#A7F1FA",fillRule:"evenodd",d:"M12 6a2.667 2.667 0 1 0 0-5.333A2.667 2.667 0 0 0 12 6m5.333 5.333v1.334c0 .736-.597 1.333-1.333 1.333s-1.333.597-1.333 1.333v4a2.667 2.667 0 1 1-5.334 0v-4C9.333 14.597 8.736 14 8 14a1.333 1.333 0 0 1-1.333-1.333v-1.334a5.333 5.333 0 1 1 10.666 0",clipRule:"evenodd"})]}),q=e=>S.jsx("svg",{xmlns:"http://www.w3.org/2000/svg",width:"16",height:"16",fill:"none",viewBox:"0 0 16 16",children:S.jsx("path",{fill:"var(--main-200)",fillRule:"evenodd",d:"M8 14.25a6.25 6.25 0 1 0 0-12.5 6.25 6.25 0 0 0 0 12.5m2.87-7.837a.469.469 0 1 0-.74-.576l-2.504 3.22a.156.156 0 0 1-.228.02L5.814 7.652a.469.469 0 0 0-.628.696l1.585 1.426c.472.425 1.205.36 1.595-.141z",clipRule:"evenodd"})});var X=function(){return X=Object.assign||function(e){for(var t,r=1,n=arguments.length;r<n;r++)for(var o in t=arguments[r])Object.prototype.hasOwnProperty.call(t,o)&&(e[o]=t[o]);return e},X.apply(this,arguments)};function J(e,t,r){if(r||2===arguments.length)for(var n,o=0,i=t.length;o<i;o++)!n&&o in t||(n||(n=Array.prototype.slice.call(t,0,o)),n[o]=t[o]);return e.concat(n||Array.prototype.slice.call(t))}"function"==typeof SuppressedError&&SuppressedError;var K="-ms-",Z="-moz-",Q="-webkit-",ee="comm",te="rule",re="decl",ne="@keyframes",oe=Math.abs,ie=String.fromCharCode,ae=Object.assign;function se(e){return e.trim()}function ce(e,t){return(e=t.exec(e))?e[0]:e}function le(e,t,r){return e.replace(t,r)}function ue(e,t,r){return e.indexOf(t,r)}function de(e,t){return 0|e.charCodeAt(t)}function pe(e,t,r){return e.slice(t,r)}function fe(e){return e.length}function he(e){return e.length}function me(e,t){return t.push(e),e}function ge(e,t){return e.filter(function(e){return!ce(e,t)})}var ve=1,ye=1,xe=0,be=0,we=0,je="";function ke(e,t,r,n,o,i,a,s){return{value:e,root:t,parent:r,type:n,props:o,children:i,line:ve,column:ye,length:a,return:"",siblings:s}}function Se(e,t){return ae(ke("",null,null,"",null,null,0,e.siblings),e,{length:-e.length},t)}function Ce(e){for(;e.root;)e=Se(e.root,{children:[e]});me(e,e.siblings)}function _e(){return we=be>0?de(je,--be):0,ye--,10===we&&(ye=1,ve--),we}function Ae(){return we=be<xe?de(je,be++):0,ye++,10===we&&(ye=1,ve++),we}function Ee(){return de(je,be)}function Ie(){return be}function Pe(e,t){return pe(je,e,t)}function Re(e){switch(e){case 0:case 9:case 10:case 13:case 32:return 5;case 33:case 43:case 44:case 47:case 62:case 64:case 126:case 59:case 123:case 125:return 4;case 58:return 3;case 34:case 39:case 40:case 91:return 2;case 41:case 93:return 1}return 0}function ze(e){return se(Pe(be-1,Me(91===e?e+2:40===e?e+1:e)))}function $e(e){for(;(we=Ee())&&we<33;)Ae();return Re(e)>2||Re(we)>3?"":" "}function De(e,t){for(;--t&&Ae()&&!(we<48||we>102||we>57&&we<65||we>70&&we<97););return Pe(e,Ie()+(t<6&&32==Ee()&&32==Ae()))}function Me(e){for(;Ae();)switch(we){case e:return be;case 34:case 39:34!==e&&39!==e&&Me(we);break;case 40:41===e&&Me(e);break;case 92:Ae()}return be}function Fe(e,t){for(;Ae()&&e+we!==57&&(e+we!==84||47!==Ee()););return"/*"+Pe(t,be-1)+"*"+ie(47===e?e:Ae())}function Ne(e){for(;!Re(Ee());)Ae();return Pe(e,be)}function Le(e){return function(e){return je="",e}(Te("",null,null,null,[""],e=function(e){return ve=ye=1,xe=fe(je=e),be=0,[]}(e),0,[0],e))}function Te(e,t,r,n,o,i,a,s,c){for(var l=0,u=0,d=a,p=0,f=0,h=0,m=1,g=1,v=1,y=0,x="",b=o,w=i,j=n,k=x;g;)switch(h=y,y=Ae()){case 40:if(108!=h&&58==de(k,d-1)){-1!=ue(k+=le(ze(y),"&","&\f"),"&\f",oe(l?s[l-1]:0))&&(v=-1);break}case 34:case 39:case 91:k+=ze(y);break;case 9:case 10:case 13:case 32:k+=$e(h);break;case 92:k+=De(Ie()-1,7);continue;case 47:switch(Ee()){case 42:case 47:me(Be(Fe(Ae(),Ie()),t,r,c),c);break;default:k+="/"}break;case 123*m:s[l++]=fe(k)*v;case 125*m:case 59:case 0:switch(y){case 0:case 125:g=0;case 59+u:-1==v&&(k=le(k,/\f/g,"")),f>0&&fe(k)-d&&me(f>32?We(k+";",n,r,d-1,c):We(le(k," ","")+";",n,r,d-2,c),c);break;case 59:k+=";";default:if(me(j=Oe(k,t,r,l,u,o,s,x,b=[],w=[],d,i),i),123===y)if(0===u)Te(k,t,j,j,b,i,d,s,w);else switch(99===p&&110===de(k,3)?100:p){case 100:case 108:case 109:case 115:Te(e,j,j,n&&me(Oe(e,j,j,0,0,o,s,x,o,b=[],d,w),w),o,w,d,s,n?b:w);break;default:Te(k,j,j,j,[""],w,0,s,w)}}l=u=f=0,m=v=1,x=k="",d=a;break;case 58:d=1+fe(k),f=h;default:if(m<1)if(123==y)--m;else if(125==y&&0==m++&&125==_e())continue;switch(k+=ie(y),y*m){case 38:v=u>0?1:(k+="\f",-1);break;case 44:s[l++]=(fe(k)-1)*v,v=1;break;case 64:45===Ee()&&(k+=ze(Ae())),p=Ee(),u=d=fe(x=k+=Ne(Ie())),y++;break;case 45:45===h&&2==fe(k)&&(m=0)}}return i}function Oe(e,t,r,n,o,i,a,s,c,l,u,d){for(var p=o-1,f=0===o?i:[""],h=he(f),m=0,g=0,v=0;m<n;++m)for(var y=0,x=pe(e,p+1,p=oe(g=a[m])),b=e;y<h;++y)(b=se(g>0?f[y]+" "+x:le(x,/&\f/g,f[y])))&&(c[v++]=b);return ke(e,t,r,0===o?te:s,c,l,u,d)}function Be(e,t,r,n){return ke(e,t,r,ee,ie(we),pe(e,2,-2),0,n)}function We(e,t,r,n,o){return ke(e,t,r,re,pe(e,0,n),pe(e,n+1,-1),n,o)}function He(e,t,r){switch(function(e,t){return 45^de(e,0)?(((t<<2^de(e,0))<<2^de(e,1))<<2^de(e,2))<<2^de(e,3):0}(e,t)){case 5103:return Q+"print-"+e+e;case 5737:case 4201:case 3177:case 3433:case 1641:case 4457:case 2921:case 5572:case 6356:case 5844:case 3191:case 6645:case 3005:case 6391:case 5879:case 5623:case 6135:case 4599:case 4855:case 4215:case 6389:case 5109:case 5365:case 5621:case 3829:return Q+e+e;case 4789:return Z+e+e;case 5349:case 4246:case 4810:case 6968:case 2756:return Q+e+Z+e+K+e+e;case 5936:switch(de(e,t+11)){case 114:return Q+e+K+le(e,/[svh]\w+-[tblr]{2}/,"tb")+e;case 108:return Q+e+K+le(e,/[svh]\w+-[tblr]{2}/,"tb-rl")+e;case 45:return Q+e+K+le(e,/[svh]\w+-[tblr]{2}/,"lr")+e}case 6828:case 4268:case 2903:return Q+e+K+e+e;case 6165:return Q+e+K+"flex-"+e+e;case 5187:return Q+e+le(e,/(\w+).+(:[^]+)/,Q+"box-$1$2"+K+"flex-$1$2")+e;case 5443:return Q+e+K+"flex-item-"+le(e,/flex-|-self/g,"")+(ce(e,/flex-|baseline/)?"":K+"grid-row-"+le(e,/flex-|-self/g,""))+e;case 4675:return Q+e+K+"flex-line-pack"+le(e,/align-content|flex-|-self/g,"")+e;case 5548:return Q+e+K+le(e,"shrink","negative")+e;case 5292:return Q+e+K+le(e,"basis","preferred-size")+e;case 6060:return Q+"box-"+le(e,"-grow","")+Q+e+K+le(e,"grow","positive")+e;case 4554:return Q+le(e,/([^-])(transform)/g,"$1"+Q+"$2")+e;case 6187:return le(le(le(e,/(zoom-|grab)/,Q+"$1"),/(image-set)/,Q+"$1"),e,"")+e;case 5495:case 3959:return le(e,/(image-set\([^]*)/,Q+"$1$`$1");case 4968:return le(le(e,/(.+:)(flex-)?(.*)/,Q+"box-pack:$3"+K+"flex-pack:$3"),/s.+-b[^;]+/,"justify")+Q+e+e;case 4200:if(!ce(e,/flex-|baseline/))return K+"grid-column-align"+pe(e,t)+e;break;case 2592:case 3360:return K+le(e,"template-","")+e;case 4384:case 3616:return r&&r.some(function(e,r){return t=r,ce(e.props,/grid-\w+-end/)})?~ue(e+(r=r[t].value),"span",0)?e:K+le(e,"-start","")+e+K+"grid-row-span:"+(~ue(r,"span",0)?ce(r,/\d+/):+ce(r,/\d+/)-+ce(e,/\d+/))+";":K+le(e,"-start","")+e;case 4896:case 4128:return r&&r.some(function(e){return ce(e.props,/grid-\w+-start/)})?e:K+le(le(e,"-end","-span"),"span ","")+e;case 4095:case 3583:case 4068:case 2532:return le(e,/(.+)-inline(.+)/,Q+"$1$2")+e;case 8116:case 7059:case 5753:case 5535:case 5445:case 5701:case 4933:case 4677:case 5533:case 5789:case 5021:case 4765:if(fe(e)-1-t>6)switch(de(e,t+1)){case 109:if(45!==de(e,t+4))break;case 102:return le(e,/(.+:)(.+)-([^]+)/,"$1"+Q+"$2-$3$1"+Z+(108==de(e,t+3)?"$3":"$2-$3"))+e;case 115:return~ue(e,"stretch",0)?He(le(e,"stretch","fill-available"),t,r)+e:e}break;case 5152:case 5920:return le(e,/(.+?):(\d+)(\s*\/\s*(span)?\s*(\d+))?(.*)/,function(t,r,n,o,i,a,s){return K+r+":"+n+s+(o?K+r+"-span:"+(i?a:+a-+n)+s:"")+e});case 4949:if(121===de(e,t+6))return le(e,":",":"+Q)+e;break;case 6444:switch(de(e,45===de(e,14)?18:11)){case 120:return le(e,/(.+:)([^;\s!]+)(;|(\s+)?!.+)?/,"$1"+Q+(45===de(e,14)?"inline-":"")+"box$3$1"+Q+"$2$3$1"+K+"$2box$3")+e;case 100:return le(e,":",":"+K)+e}break;case 5719:case 2647:case 2135:case 3927:case 2391:return le(e,"scroll-","scroll-snap-")+e}return e}function Ge(e,t){for(var r="",n=0;n<e.length;n++)r+=t(e[n],n,e,t)||"";return r}function Ve(e,t,r,n){switch(e.type){case"@layer":if(e.children.length)break;case"@import":case re:return e.return=e.return||e.value;case ee:return"";case ne:return e.return=e.value+"{"+Ge(e.children,n)+"}";case te:if(!fe(e.value=e.props.join(",")))return""}return fe(r=Ge(e.children,n))?e.return=e.value+"{"+r+"}":""}function Ue(e,t,r,n){if(e.length>-1&&!e.return)switch(e.type){case re:return void(e.return=He(e.value,e.length,r));case ne:return Ge([Se(e,{value:le(e.value,"@","@"+Q)})],n);case te:if(e.length)return function(e,t){return e.map(t).join("")}(r=e.props,function(t){switch(ce(t,n=/(::plac\w+|:read-\w+)/)){case":read-only":case":read-write":Ce(Se(e,{props:[le(t,/:(read-\w+)/,":-moz-$1")]})),Ce(Se(e,{props:[t]})),ae(e,{props:ge(r,n)});break;case"::placeholder":Ce(Se(e,{props:[le(t,/:(plac\w+)/,":"+Q+"input-$1")]})),Ce(Se(e,{props:[le(t,/:(plac\w+)/,":-moz-$1")]})),Ce(Se(e,{props:[le(t,/:(plac\w+)/,K+"input-$1")]})),Ce(Se(e,{props:[t]})),ae(e,{props:ge(r,n)})}return""})}}var Ye={animationIterationCount:1,aspectRatio:1,borderImageOutset:1,borderImageSlice:1,borderImageWidth:1,boxFlex:1,boxFlexGroup:1,boxOrdinalGroup:1,columnCount:1,columns:1,flex:1,flexGrow:1,flexPositive:1,flexShrink:1,flexNegative:1,flexOrder:1,gridRow:1,gridRowEnd:1,gridRowSpan:1,gridRowStart:1,gridColumn:1,gridColumnEnd:1,gridColumnSpan:1,gridColumnStart:1,msGridRow:1,msGridRowSpan:1,msGridColumn:1,msGridColumnSpan:1,fontWeight:1,lineHeight:1,opacity:1,order:1,orphans:1,tabSize:1,widows:1,zIndex:1,zoom:1,WebkitLineClamp:1,fillOpacity:1,floodOpacity:1,stopOpacity:1,strokeDasharray:1,strokeDashoffset:1,strokeMiterlimit:1,strokeOpacity:1,strokeWidth:1},qe={},Xe="undefined"!=typeof process&&void 0!==qe&&(qe.REACT_APP_SC_ATTR||qe.SC_ATTR)||"data-styled",Je="active",Ke="data-styled-version",Ze="6.1.19",Qe="/*!sc*/\n",et="undefined"!=typeof window&&"undefined"!=typeof document,tt=Boolean("boolean"==typeof SC_DISABLE_SPEEDY?SC_DISABLE_SPEEDY:"undefined"!=typeof process&&void 0!==qe&&void 0!==qe.REACT_APP_SC_DISABLE_SPEEDY&&""!==qe.REACT_APP_SC_DISABLE_SPEEDY?"false"!==qe.REACT_APP_SC_DISABLE_SPEEDY&&qe.REACT_APP_SC_DISABLE_SPEEDY:"undefined"!=typeof process&&void 0!==qe&&void 0!==qe.SC_DISABLE_SPEEDY&&""!==qe.SC_DISABLE_SPEEDY&&("false"!==qe.SC_DISABLE_SPEEDY&&qe.SC_DISABLE_SPEEDY)),rt=Object.freeze([]),nt=Object.freeze({});var ot=new Set(["a","abbr","address","area","article","aside","audio","b","base","bdi","bdo","big","blockquote","body","br","button","canvas","caption","cite","code","col","colgroup","data","datalist","dd","del","details","dfn","dialog","div","dl","dt","em","embed","fieldset","figcaption","figure","footer","form","h1","h2","h3","h4","h5","h6","header","hgroup","hr","html","i","iframe","img","input","ins","kbd","keygen","label","legend","li","link","main","map","mark","menu","menuitem","meta","meter","nav","noscript","object","ol","optgroup","option","output","p","param","picture","pre","progress","q","rp","rt","ruby","s","samp","script","section","select","small","source","span","strong","style","sub","summary","sup","table","tbody","td","textarea","tfoot","th","thead","time","tr","track","u","ul","use","var","video","wbr","circle","clipPath","defs","ellipse","foreignObject","g","image","line","linearGradient","marker","mask","path","pattern","polygon","polyline","radialGradient","rect","stop","svg","text","tspan"]),it=/[!"#$%&'()*+,./:;<=>?@[\\\]^`{|}~-]+/g,at=/(^-|-$)/g;function st(e){return e.replace(it,"-").replace(at,"")}var ct=/(a)(d)/gi,lt=function(e){return String.fromCharCode(e+(e>25?39:97))};function ut(e){var t,r="";for(t=Math.abs(e);t>52;t=t/52|0)r=lt(t%52)+r;return(lt(t%52)+r).replace(ct,"$1-$2")}var dt,pt=function(e,t){for(var r=t.length;r;)e=33*e^t.charCodeAt(--r);return e},ft=function(e){return pt(5381,e)};function ht(e){return"string"==typeof e&&!0}var mt="function"==typeof Symbol&&Symbol.for,gt=mt?Symbol.for("react.memo"):60115,vt=mt?Symbol.for("react.forward_ref"):60112,yt={childContextTypes:!0,contextType:!0,contextTypes:!0,defaultProps:!0,displayName:!0,getDefaultProps:!0,getDerivedStateFromError:!0,getDerivedStateFromProps:!0,mixins:!0,propTypes:!0,type:!0},xt={name:!0,length:!0,prototype:!0,caller:!0,callee:!0,arguments:!0,arity:!0},bt={$$typeof:!0,compare:!0,defaultProps:!0,displayName:!0,propTypes:!0,type:!0},wt=((dt={})[vt]={$$typeof:!0,render:!0,defaultProps:!0,displayName:!0,propTypes:!0},dt[gt]=bt,dt);function jt(e){return("type"in(t=e)&&t.type.$$typeof)===gt?bt:"$$typeof"in e?wt[e.$$typeof]:yt;var t}var kt=Object.defineProperty,St=Object.getOwnPropertyNames,Ct=Object.getOwnPropertySymbols,_t=Object.getOwnPropertyDescriptor,At=Object.getPrototypeOf,Et=Object.prototype;function It(e,t,r){if("string"!=typeof t){if(Et){var n=At(t);n&&n!==Et&&It(e,n,r)}var o=St(t);Ct&&(o=o.concat(Ct(t)));for(var i=jt(e),a=jt(t),s=0;s<o.length;++s){var c=o[s];if(!(c in xt||r&&r[c]||a&&c in a||i&&c in i)){var l=_t(t,c);try{kt(e,c,l)}catch(u){}}}}return e}function Pt(e){return"function"==typeof e}function Rt(e){return"object"==typeof e&&"styledComponentId"in e}function zt(e,t){return e&&t?"".concat(e," ").concat(t):e||t||""}function $t(e,t){if(0===e.length)return"";for(var r=e[0],n=1;n<e.length;n++)r+=e[n];return r}function Dt(e){return null!==e&&"object"==typeof e&&e.constructor.name===Object.name&&!("props"in e&&e.$$typeof)}function Mt(e,t,r){if(void 0===r&&(r=!1),!r&&!Dt(e)&&!Array.isArray(e))return t;if(Array.isArray(t))for(var n=0;n<t.length;n++)e[n]=Mt(e[n],t[n]);else if(Dt(t))for(var n in t)e[n]=Mt(e[n],t[n]);return e}function Ft(e,t){Object.defineProperty(e,"toString",{value:t})}function Nt(e){for(var t=[],r=1;r<arguments.length;r++)t[r-1]=arguments[r];return new Error("An error occurred. See https://github.com/styled-components/styled-components/blob/main/packages/styled-components/src/utils/errors.md#".concat(e," for more information.").concat(t.length>0?" Args: ".concat(t.join(", ")):""))}var Lt=function(){function e(e){this.groupSizes=new Uint32Array(512),this.length=512,this.tag=e}return e.prototype.indexOfGroup=function(e){for(var t=0,r=0;r<e;r++)t+=this.groupSizes[r];return t},e.prototype.insertRules=function(e,t){if(e>=this.groupSizes.length){for(var r=this.groupSizes,n=r.length,o=n;e>=o;)if((o<<=1)<0)throw Nt(16,"".concat(e));this.groupSizes=new Uint32Array(o),this.groupSizes.set(r),this.length=o;for(var i=n;i<o;i++)this.groupSizes[i]=0}for(var a=this.indexOfGroup(e+1),s=(i=0,t.length);i<s;i++)this.tag.insertRule(a,t[i])&&(this.groupSizes[e]++,a++)},e.prototype.clearGroup=function(e){if(e<this.length){var t=this.groupSizes[e],r=this.indexOfGroup(e),n=r+t;this.groupSizes[e]=0;for(var o=r;o<n;o++)this.tag.deleteRule(r)}},e.prototype.getGroup=function(e){var t="";if(e>=this.length||0===this.groupSizes[e])return t;for(var r=this.groupSizes[e],n=this.indexOfGroup(e),o=n+r,i=n;i<o;i++)t+="".concat(this.tag.getRule(i)).concat(Qe);return t},e}(),Tt=new Map,Ot=new Map,Bt=1,Wt=function(e){if(Tt.has(e))return Tt.get(e);for(;Ot.has(Bt);)Bt++;var t=Bt++;return Tt.set(e,t),Ot.set(t,e),t},Ht=function(e,t){Bt=t+1,Tt.set(e,t),Ot.set(t,e)},Gt="style[".concat(Xe,"][").concat(Ke,'="').concat(Ze,'"]'),Vt=new RegExp("^".concat(Xe,'\\.g(\\d+)\\[id="([\\w\\d-]+)"\\].*?"([^"]*)')),Ut=function(e,t,r){for(var n,o=r.split(","),i=0,a=o.length;i<a;i++)(n=o[i])&&e.registerName(t,n)},Yt=function(e,t){for(var r,n=(null!==(r=t.textContent)&&void 0!==r?r:"").split(Qe),o=[],i=0,a=n.length;i<a;i++){var s=n[i].trim();if(s){var c=s.match(Vt);if(c){var l=0|parseInt(c[1],10),u=c[2];0!==l&&(Ht(u,l),Ut(e,u,c[3]),e.getTag().insertRules(l,o)),o.length=0}else o.push(s)}}},qt=function(e){for(var t=document.querySelectorAll(Gt),r=0,n=t.length;r<n;r++){var o=t[r];o&&o.getAttribute(Xe)!==Je&&(Yt(e,o),o.parentNode&&o.parentNode.removeChild(o))}};var Xt=function(e){var t,r,n=document.head,o=e||n,i=document.createElement("style"),a=(t=o,(r=Array.from(t.querySelectorAll("style[".concat(Xe,"]"))))[r.length-1]),s=void 0!==a?a.nextSibling:null;i.setAttribute(Xe,Je),i.setAttribute(Ke,Ze);var c="undefined"!=typeof __webpack_nonce__?__webpack_nonce__:null;return c&&i.setAttribute("nonce",c),o.insertBefore(i,s),i},Jt=function(){function e(e){this.element=Xt(e),this.element.appendChild(document.createTextNode("")),this.sheet=function(e){if(e.sheet)return e.sheet;for(var t=document.styleSheets,r=0,n=t.length;r<n;r++){var o=t[r];if(o.ownerNode===e)return o}throw Nt(17)}(this.element),this.length=0}return e.prototype.insertRule=function(e,t){try{return this.sheet.insertRule(t,e),this.length++,!0}catch(r){return!1}},e.prototype.deleteRule=function(e){this.sheet.deleteRule(e),this.length--},e.prototype.getRule=function(e){var t=this.sheet.cssRules[e];return t&&t.cssText?t.cssText:""},e}(),Kt=function(){function e(e){this.element=Xt(e),this.nodes=this.element.childNodes,this.length=0}return e.prototype.insertRule=function(e,t){if(e<=this.length&&e>=0){var r=document.createTextNode(t);return this.element.insertBefore(r,this.nodes[e]||null),this.length++,!0}return!1},e.prototype.deleteRule=function(e){this.element.removeChild(this.nodes[e]),this.length--},e.prototype.getRule=function(e){return e<this.length?this.nodes[e].textContent:""},e}(),Zt=function(){function e(e){this.rules=[],this.length=0}return e.prototype.insertRule=function(e,t){return e<=this.length&&(this.rules.splice(e,0,t),this.length++,!0)},e.prototype.deleteRule=function(e){this.rules.splice(e,1),this.length--},e.prototype.getRule=function(e){return e<this.length?this.rules[e]:""},e}(),Qt=et,er={isServer:!et,useCSSOMInjection:!tt},tr=function(){function e(e,t,r){void 0===e&&(e=nt),void 0===t&&(t={});var n=this;this.options=X(X({},er),e),this.gs=t,this.names=new Map(r),this.server=!!e.isServer,!this.server&&et&&Qt&&(Qt=!1,qt(this)),Ft(this,function(){return function(e){for(var t=e.getTag(),r=t.length,n="",o=function(r){var o,i=(o=r,Ot.get(o));if(void 0===i)return"continue";var a=e.names.get(i),s=t.getGroup(r);if(void 0===a||!a.size||0===s.length)return"continue";var c="".concat(Xe,".g").concat(r,'[id="').concat(i,'"]'),l="";void 0!==a&&a.forEach(function(e){e.length>0&&(l+="".concat(e,","))}),n+="".concat(s).concat(c,'{content:"').concat(l,'"}').concat(Qe)},i=0;i<r;i++)o(i);return n}(n)})}return e.registerId=function(e){return Wt(e)},e.prototype.rehydrate=function(){!this.server&&et&&qt(this)},e.prototype.reconstructWithOptions=function(t,r){return void 0===r&&(r=!0),new e(X(X({},this.options),t),this.gs,r&&this.names||void 0)},e.prototype.allocateGSInstance=function(e){return this.gs[e]=(this.gs[e]||0)+1},e.prototype.getTag=function(){return this.tag||(this.tag=(e=this.options,t=e.useCSSOMInjection,r=e.target,n=e.isServer?new Zt(r):t?new Jt(r):new Kt(r),new Lt(n)));var e,t,r,n},e.prototype.hasNameForId=function(e,t){return this.names.has(e)&&this.names.get(e).has(t)},e.prototype.registerName=function(e,t){if(Wt(e),this.names.has(e))this.names.get(e).add(t);else{var r=new Set;r.add(t),this.names.set(e,r)}},e.prototype.insertRules=function(e,t,r){this.registerName(e,t),this.getTag().insertRules(Wt(e),r)},e.prototype.clearNames=function(e){this.names.has(e)&&this.names.get(e).clear()},e.prototype.clearRules=function(e){this.getTag().clearGroup(Wt(e)),this.clearNames(e)},e.prototype.clearTag=function(){this.tag=void 0},e}(),rr=/&/g,nr=/^\s*\/\/.*$/gm;function or(e,t){return e.map(function(e){return"rule"===e.type&&(e.value="".concat(t," ").concat(e.value),e.value=e.value.replaceAll(",",",".concat(t," ")),e.props=e.props.map(function(e){return"".concat(t," ").concat(e)})),Array.isArray(e.children)&&"@keyframes"!==e.type&&(e.children=or(e.children,t)),e})}var ir=new tr,ar=function(){var e,t,r,n=nt,o=n.options,i=void 0===o?nt:o,a=n.plugins,s=void 0===a?rt:a,c=function(r,n,o){return o.startsWith(t)&&o.endsWith(t)&&o.replaceAll(t,"").length>0?".".concat(e):r},l=s.slice();l.push(function(e){e.type===te&&e.value.includes("&")&&(e.props[0]=e.props[0].replace(rr,t).replace(r,c))}),i.prefix&&l.push(Ue),l.push(Ve);var u=function(n,o,a,s){void 0===o&&(o=""),void 0===a&&(a=""),void 0===s&&(s="&"),e=s,t=o,r=new RegExp("\\".concat(t,"\\b"),"g");var c=n.replace(nr,""),u=Le(a||o?"".concat(a," ").concat(o," { ").concat(c," }"):c);i.namespace&&(u=or(u,i.namespace));var d,p,f,h=[];return Ge(u,(d=l.concat((f=function(e){return h.push(e)},function(e){e.root||(e=e.return)&&f(e)})),p=he(d),function(e,t,r,n){for(var o="",i=0;i<p;i++)o+=d[i](e,t,r,n)||"";return o})),h};return u.hash=s.length?s.reduce(function(e,t){return t.name||Nt(15),pt(e,t.name)},5381).toString():"",u}(),sr=r.createContext({shouldForwardProp:void 0,styleSheet:ir,stylis:ar});function cr(){return e.useContext(sr)}sr.Consumer,r.createContext(void 0);var lr=function(){function e(e,t){var r=this;this.inject=function(e,t){void 0===t&&(t=ar);var n=r.name+t.hash;e.hasNameForId(r.id,n)||e.insertRules(r.id,n,t(r.rules,n,"@keyframes"))},this.name=e,this.id="sc-keyframes-".concat(e),this.rules=t,Ft(this,function(){throw Nt(12,String(r.name))})}return e.prototype.getName=function(e){return void 0===e&&(e=ar),this.name+e.hash},e}(),ur=function(e){return e>="A"&&e<="Z"};function dr(e){for(var t="",r=0;r<e.length;r++){var n=e[r];if(1===r&&"-"===n&&"-"===e[0])return e;ur(n)?t+="-"+n.toLowerCase():t+=n}return t.startsWith("ms-")?"-"+t:t}var pr=function(e){return null==e||!1===e||""===e},fr=function(e){var t,r,n=[];for(var o in e){var i=e[o];e.hasOwnProperty(o)&&!pr(i)&&(Array.isArray(i)&&i.isCss||Pt(i)?n.push("".concat(dr(o),":"),i,";"):Dt(i)?n.push.apply(n,J(J(["".concat(o," {")],fr(i),!1),["}"],!1)):n.push("".concat(dr(o),": ").concat((t=o,null==(r=i)||"boolean"==typeof r||""===r?"":"number"!=typeof r||0===r||t in Ye||t.startsWith("--")?String(r).trim():"".concat(r,"px")),";")))}return n};function hr(e,t,r,n){return pr(e)?[]:Rt(e)?[".".concat(e.styledComponentId)]:Pt(e)?!Pt(o=e)||o.prototype&&o.prototype.isReactComponent||!t?[e]:hr(e(t),t,r,n):e instanceof lr?r?(e.inject(r,n),[e.getName(n)]):[e]:Dt(e)?fr(e):Array.isArray(e)?Array.prototype.concat.apply(rt,e.map(function(e){return hr(e,t,r,n)})):[e.toString()];var o}var mr=ft(Ze),gr=function(){function e(e,t,r){this.rules=e,this.staticRulesId="",this.isStatic=(void 0===r||r.isStatic)&&function(e){for(var t=0;t<e.length;t+=1){var r=e[t];if(Pt(r)&&!Rt(r))return!1}return!0}(e),this.componentId=t,this.baseHash=pt(mr,t),this.baseStyle=r,tr.registerId(t)}return e.prototype.generateAndInjectStyles=function(e,t,r){var n=this.baseStyle?this.baseStyle.generateAndInjectStyles(e,t,r):"";if(this.isStatic&&!r.hash)if(this.staticRulesId&&t.hasNameForId(this.componentId,this.staticRulesId))n=zt(n,this.staticRulesId);else{var o=$t(hr(this.rules,e,t,r)),i=ut(pt(this.baseHash,o)>>>0);if(!t.hasNameForId(this.componentId,i)){var a=r(o,".".concat(i),void 0,this.componentId);t.insertRules(this.componentId,i,a)}n=zt(n,i),this.staticRulesId=i}else{for(var s=pt(this.baseHash,r.hash),c="",l=0;l<this.rules.length;l++){var u=this.rules[l];if("string"==typeof u)c+=u;else if(u){var d=$t(hr(u,e,t,r));s=pt(s,d+l),c+=d}}if(c){var p=ut(s>>>0);t.hasNameForId(this.componentId,p)||t.insertRules(this.componentId,p,r(c,".".concat(p),void 0,this.componentId)),n=zt(n,p)}}return n},e}(),vr=r.createContext(void 0);vr.Consumer;var yr={};function xr(t,n,o){var i,a=Rt(t),s=t,c=!ht(t),l=n.attrs,u=void 0===l?rt:l,d=n.componentId,p=void 0===d?function(e,t){var r="string"!=typeof e?"sc":st(e);yr[r]=(yr[r]||0)+1;var n="".concat(r,"-").concat(function(e){return ut(ft(e)>>>0)}(Ze+r+yr[r]));return t?"".concat(t,"-").concat(n):n}(n.displayName,n.parentComponentId):d,f=n.displayName,h=void 0===f?ht(i=t)?"styled.".concat(i):"Styled(".concat(function(e){return e.displayName||e.name||"Component"}(i),")"):f,m=n.displayName&&n.componentId?"".concat(st(n.displayName),"-").concat(n.componentId):n.componentId||p,g=a&&s.attrs?s.attrs.concat(u).filter(Boolean):u,v=n.shouldForwardProp;if(a&&s.shouldForwardProp){var y=s.shouldForwardProp;if(n.shouldForwardProp){var x=n.shouldForwardProp;v=function(e,t){return y(e,t)&&x(e,t)}}else v=y}var b=new gr(o,m,a?s.componentStyle:void 0);function w(t,n){return function(t,n,o){var i=t.attrs,a=t.componentStyle,s=t.defaultProps,c=t.foldedComponentIds,l=t.styledComponentId,u=t.target,d=r.useContext(vr),p=cr(),f=t.shouldForwardProp||p.shouldForwardProp,h=function(e,t,r){return void 0===r&&(r=nt),e.theme!==r.theme&&e.theme||t||r.theme}(n,d,s)||nt,m=function(e,t,r){for(var n,o=X(X({},t),{className:void 0,theme:r}),i=0;i<e.length;i+=1){var a=Pt(n=e[i])?n(o):n;for(var s in a)o[s]="className"===s?zt(o[s],a[s]):"style"===s?X(X({},o[s]),a[s]):a[s]}return t.className&&(o.className=zt(o.className,t.className)),o}(i,n,h),g=m.as||u,v={};for(var y in m)void 0===m[y]||"$"===y[0]||"as"===y||"theme"===y&&m.theme===h||("forwardedAs"===y?v.as=m.forwardedAs:f&&!f(y,g)||(v[y]=m[y]));var x,b,w,j=(x=a,b=m,w=cr(),x.generateAndInjectStyles(b,w.styleSheet,w.stylis)),k=zt(c,l);return j&&(k+=" "+j),m.className&&(k+=" "+m.className),v[ht(g)&&!ot.has(g)?"class":"className"]=k,o&&(v.ref=o),e.createElement(g,v)}(j,t,n)}w.displayName=h;var j=r.forwardRef(w);return j.attrs=g,j.componentStyle=b,j.displayName=h,j.shouldForwardProp=v,j.foldedComponentIds=a?zt(s.foldedComponentIds,s.styledComponentId):"",j.styledComponentId=m,j.target=a?s.target:t,Object.defineProperty(j,"defaultProps",{get:function(){return this._foldedDefaultProps},set:function(e){this._foldedDefaultProps=a?function(e){for(var t=[],r=1;r<arguments.length;r++)t[r-1]=arguments[r];for(var n=0,o=t;n<o.length;n++)Mt(e,o[n],!0);return e}({},s.defaultProps,e):e}}),Ft(j,function(){return".".concat(j.styledComponentId)}),c&&It(j,t,{attrs:!0,componentStyle:!0,displayName:!0,foldedComponentIds:!0,shouldForwardProp:!0,styledComponentId:!0,target:!0}),j}function br(e,t){for(var r=[e[0]],n=0,o=t.length;n<o;n+=1)r.push(t[n],e[n+1]);return r}var wr=function(e){return Object.assign(e,{isCss:!0})};function jr(e){for(var t=[],r=1;r<arguments.length;r++)t[r-1]=arguments[r];if(Pt(e)||Dt(e))return wr(hr(br(rt,J([e],t,!0))));var n=e;return 0===t.length&&1===n.length&&"string"==typeof n[0]?hr(n):wr(hr(br(n,t)))}function kr(e,t,r){if(void 0===r&&(r=nt),!t)throw Nt(1,t);var n=function(n){for(var o=[],i=1;i<arguments.length;i++)o[i-1]=arguments[i];return e(t,r,jr.apply(void 0,J([n],o,!1)))};return n.attrs=function(n){return kr(e,t,X(X({},r),{attrs:Array.prototype.concat(r.attrs,n).filter(Boolean)}))},n.withConfig=function(n){return kr(e,t,X(X({},r),n))},n}var Sr=function(e){return kr(xr,e)},Cr=Sr;ot.forEach(function(e){Cr[e]=Sr(e)});const _r=Cr.div`
	min-height: 100vh;
	width: 100vw;
	// background: #eaeaea;
	position: relative;
	overflow: hidden;
`,Ar=Cr.div`
	position: absolute;
	top: 30%;
	left: 4rem;
	background: var(--background-solid);
	color: #fff;
	border-radius: 10px;
	box-shadow: 0 4px 24px rgba(0,0,0,0.2);
	padding: 1.6rem 1.6rem;
	min-width: 340px;
	z-index: 10;
  overflow: hidden;

  border-radius: var(--radius-sm, 0.4rem);
  border: 1px solid var(--white-opacity-100, rgba(255, 255, 255, 0.10));
  background-blend-mode: normal, normal, difference, normal;
`,Er=Cr.div`
	font-size: 1.2rem;
	font-weight: bold;
	// margin-bottom: 0.2rem;
	display: flex;
	align-items: center;
	gap: 0.5rem;

  color: var(--white-opacity-900, #FFF);

  /* h4 */
  font-family: Inter;
  font-size: 2rem;
  font-style: normal;
  font-weight: 600;
  line-height: 2.8rem; /* 140% */
`,Ir=Cr.span`
  display: flex;
  width: 60px;
  height: 60px;
  // padding: 1.4rem;
  justify-content: center;
  align-items: center;
	border-radius: var(--radius-md, 0.8rem);
  border: 1px solid var(--main-500, #0DC8E7);
  background: var(--main-900, #184D61);
`,Pr=Cr.div`
  color: var(--white-opacity-500, rgba(255, 255, 255, 0.50));

  /* detail */
  font-family: Inter;
  font-size: 1.2rem;
  font-style: normal;
  font-weight: 500;
`,Rr=Cr.ul`
	list-style: none;
	padding: 0;
	margin: 0;
`,zr=Cr.hr`
  border: none;
  border-top: 1.5px solid rgba(255,255,255,0.10);
  margin: 1.1rem 0 1.3rem 0;
  width: 121%;
  transform: translateX(-8.5%);
`,$r=Cr.li`
	display: flex;
	align-items: center;
	font-size: 1rem;
	margin-bottom: 0.7rem;
	// opacity: ${e=>e.done?.6:1};
	text-decoration: ${e=>e.done?"line-through":"none"};
	color: ${e=>e.done?"var(--main-100, #D0F9FD)":"#fff"};
	transition: opacity 0.2s, color 0.2s;

  font-family: Inter;
  font-size: 1.2rem;
  font-style: normal;
  font-weight: 500;
  line-height: 2rem; /* 166.667% */
`,Dr=Cr.span`
  display: flex;
  width: 2.4rem;
  height: 2.4rem;
  justify-content: center;
  align-items: center;
  flex-shrink: 0;
  margin-right: 0.7rem;
  position: relative;
  transition: background 0.2s, border 0.2s;

  border-radius: var(--radius-xs, 0.2rem);
  border: 1px solid
    ${e=>e.checked?"var(--main-300, #6BE5F5)":"var(--white-opacity-100, rgba(255, 255, 255, 0.10))"};
  background: ${e=>e.checked?"var(--main-700, #12728C)":"var(--white-opacity-50, rgba(255, 255, 255, 0.05))"};

  &::after {
    content: '';
    display: ${e=>e.checked?"none":"block"};
  }
`,Mr=Cr.div`
	position: absolute;
	bottom: 1rem;
	left: 50%;
	transform: translateX(-50%);
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: end;
	z-index: 20;
	width: 100%;
	max-width: 300px;
	height: 100%;
	max-height: 300px;

	&::before {
		content: '';
		position: absolute;
		top: 5%;
		left: -40%;
		right: 0;
		bottom: -7%;
    width: 170%;
		background-image: url('https://santaimgrp.ecxon.com.br/img/tutorial/shadow.png');
		background-size: 100% 100%;
		background-position: center;
		background-repeat: no-repeat;
		z-index: -1;
	}
	&:hover::before {
		opacity: 1;
	}
`,Fr=Cr.div`
	display: flex;
	flex-direction: row;
	gap: 2.2rem;
	margin-top: 0.5rem;
`,Nr=Cr.div`
	min-width: 70px;
	height: 70px;
	padding: 0.5rem;
	background: transparent;
	color: #fff;
	border-radius: 16px;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 2.2rem;
	font-weight: bold;
	border: 2.5px solid rgba(255,255,255,0.35);
	transition: border 0.15s, color 0.15s;
	box-shadow: none;
	opacity: 0.85;
  border-radius: var(--radius-md, 0.8rem);
  border: 1px solid var(--white-opacity-100, rgba(255, 255, 255, 0.10));
  background: var(--white-opacity-50, rgba(255, 255, 255, 0.05));
  cursor: pointer;
  &:hover {
    border: 2.5px solid #4fc3f7;
    color: #4fc3f7;
    opacity: 1;
  }
  &:active {
    border: 2.5px solid #1976d2;
    color: #1976d2;
    opacity: 1;
  }
	${e=>e.active&&"\n\t\tborder: 2.5px solid #4fc3f7;\n\t\tcolor: #4fc3f7;\n\t\topacity: 1;\n\t"}
`;function Lr(){const[t,r]=e.useState("movement"),[n,o]=e.useState({walk:!1,jump:!1,crouch:!1,inventory:!1,enter:!1,belt:!1,ignition:!1,drive:!1}),[i,a]=e.useState({w:!1,a:!1,s:!1,d:!1,space:!1,ctrl:!1,f:!1,c:!1,z:!1,i:!1}),[s,c]=e.useState(!0),[l,u]=e.useState(!1),[p,f]=e.useState(40),{t:h}=d(),m=[{label:h("walk_step"),key:"walk"},{label:h("jump_step"),key:"jump"},{label:h("crouch_step"),key:"crouch"}],g=[{label:h("car_step_enter"),key:"enter"},{label:h("car_step_belt"),key:"belt"},{label:h("car_step_drive"),key:"drive"}],v=[{label:h("inventory_step_open"),key:"open"},{label:h("inventory_step_trash"),key:"trash"},{label:h("inventory_step_eat"),key:"eat"},{label:h("inventory_step_pickup"),key:"pickup"}],y=[{label:h("action_walk"),keys:["W","A","S","D"],key:"walk"},{label:h("action_jump"),keys:["SPACE"],key:"jump"},{label:h("action_crouch"),keys:["CTRL"],key:"crouch"}],x=[{label:h("car_step_enter"),keys:["F"],key:"enter"},{label:h("car_step_belt"),keys:["G"],key:"belt"},{label:h("car_step_drive"),keys:["W","A","S","D"],key:"drive"}],b=[{label:h("inventory_step_open"),keys:["I"],key:"open"},{label:h("inventory_step_trash"),keys:[],key:"trash"},{label:h("inventory_step_eat"),keys:[],key:"eat"},{label:h("inventory_step_pickup"),keys:[],key:"pickup"}],w={movement:{walk:!1,jump:!1,crouch:!1},car:{enter:!1,belt:!1,ignition:!1,drive:!1},inventory:{open:!1,trash:!1,eat:!1,pickup:!1}};e.useEffect(()=>{o("movement"===t||"car"===t||"inventory"===t?w[t]:{})},[t]);const j="car"===t?g:"inventory"===t?v:m,k="car"===t?x:"inventory"===t?b:y;function C(e){return"SPACE"===e?"space":"CTRL"===e?"ctrl":e.toLowerCase()}const _=Cr.div`
	  position: fixed;
	  top: 0; left: 0; right: 0; bottom: 0;
	  background: rgba(0,0,0,0.45);
	  z-index: 1000;
	  display: flex;
	  align-items: center;
	  justify-content: center;
	`,A=Cr.div`
	  background: var(--background-solid);
	  color: #fff;
	  border-radius: 12px;
	  box-shadow: 0 4px 24px rgba(0,0,0,0.2);
	  padding: 2rem 2.5rem 1.5rem 2.5rem;
	  text-align: flex-start;
    min-width: 32.2rem;

    border-radius: var(--radius-sm, 0.4rem);
        border: 1px solid var(--white-opacity-100, rgba(255, 255, 255, 0.10));
	`,E=Cr.div`
    color: var(--white-opacity-900, #FFF);

    /* h4 */
    font-family: Inter;
    font-size: 2rem;
    font-style: normal;
    font-weight: 600;
    line-height: 2.4rem;
	`,I=Cr.div`
    color: var(--white-opacity-500, rgba(255, 255, 255, 0.50));

    /* small */
    font-family: Inter;
    font-size: 1.4rem;
    font-style: normal;
    font-weight: 500;
    margin-bottom: 1.6rem;
	`,P=Cr.div`
	  display: flex;
	  gap: 1rem;
	  justify-content: center;
	`,R=Cr.button`
	  color: #fff;
	  border: none;
	  padding: 0.7rem 2.2rem;
	  font-size: 1.4rem;
	  font-weight: 600;
	  cursor: pointer;
	  transition: background 0.2s;
	  color: var(--main-950, #0A3242);
	  width: 100%;

    border-radius: 0.6rem;
    background: var(--main-500, #0DC8E7);
	  &:hover {
	    color: #fff;
	    background: var(--main-950, #0A3242);
	  }
	`,$=Cr(R)`
	  background: var(--white-opacity-50, rgba(255, 255, 255, 0.05));
	  color: var(--white-opacity-500, rgba(255, 255, 255, 0.50));
	  width: 100%;
	  &:hover {
	    background: var(--white-opacity-100, rgba(255, 255, 255, 0.10));
	    color: #fff;
	  }
	`;H("setTutorialVisible",e=>{c(e),e||u(!1)}),H("updateTutorialProgress",e=>{o(t=>({...t,...e}))}),H("updateTutorialType",e=>{r(e)}),e.useEffect(()=>{const e=e=>{const r=e.key.toLowerCase();"car"===t?("f"===r&&(a(e=>({...e,f:!0})),o(e=>({...e,enter:!0}))),"b"===r&&(a(e=>({...e,b:!0})),o(e=>({...e,belt:!0}))),"l"===r&&(a(e=>({...e,l:!0})),o(e=>({...e,ignition:!0}))),["w","a","s","d"].includes(r)&&(a(e=>({...e,[r]:!0})),o(e=>({...e,drive:!0})))):"inventory"===t?("i"===r&&o(e=>({...e,open:!0})),"del"===r&&o(e=>({...e,trash:!0})),"e"===r&&o(e=>({...e,eat:!0})),"p"===r&&o(e=>({...e,pickup:!0}))):(["w","a","s","d","f","c","z","i"].includes(r)&&(a(e=>({...e,[r]:!0})),["w","a","s","d"].includes(r)&&o(e=>({...e,walk:!0})))," "!==r&&"spacebar"!==r||(a(e=>({...e,space:!0})),o(e=>({...e,jump:!0}))),"control"!==r&&"ctrl"!==r||(a(e=>({...e,ctrl:!0})),o(e=>({...e,crouch:!0}))),"i"===r&&o(e=>({...e,inventory:!0})))},r=e=>{const t=e.key.toLowerCase();a(e=>({...e,[t]:!1}))};return window.addEventListener("keydown",e),window.addEventListener("keyup",r),()=>{window.removeEventListener("keydown",e),window.removeEventListener("keyup",r)}},[t]);const M=j.find(e=>!n[e.key]),F=k.find(e=>e.key===(null==M?void 0:M.key)),N=F?F.keys:[];return e.useEffect(()=>{window.focus()},[]),e.useEffect(()=>{if(!s)return;if(p<=0)return c(!1),u(!1),void D({path:"tutorialAccepted",payload:{accepted:!1}});const e=setTimeout(()=>f(e=>e-1),1e3);return()=>clearTimeout(e)},[p,s]),s?S.jsx(_,{children:S.jsxs(A,{children:[S.jsx(E,{children:h("tutorial_prompt_title")}),S.jsx(I,{children:h("tutorial_prompt_desc")}),S.jsxs(P,{children:[S.jsx(R,{onClick:()=>{c(!1),u(!0),z()||D({path:"tutorialAccepted",payload:{accepted:!0}})},children:h("btn_yes")}),S.jsx($,{onClick:()=>{c(!1),u(!1),z()||D({path:"tutorialAccepted",payload:{accepted:!1}})},children:h("btn_skip")})]}),S.jsxs("div",{style:{textAlign:"center",marginTop:"1.2rem",color:"var(--white-opacity-500, rgba(255, 255, 255, 0.50))",fontSize:"1.2rem",fontWeight:500},children:[h("skipping_tutorial_in")," ",S.jsxs("span",{style:{color:"var(--main-200, #A7F1FA)",fontWeight:500},children:[p," ",h("seconds")]})]})]})}):l?S.jsxs(_r,{style:{display:"flex",alignItems:"flex-start",height:"100vh"},children:[S.jsxs(Ar,{children:[S.jsxs("div",{style:{display:"flex",alignItems:"center",justifyContent:"flex-start",gap:"12px",marginBottom:"1.2rem"},children:[S.jsx(Ir,{children:"movement"===t?S.jsx(Y,{style:{width:"24px",height:"28px"}}):"inventory"===t?S.jsx(V,{style:{width:"24px",height:"28px"}}):S.jsx(U,{style:{width:"24px",height:"28px"}})}),S.jsxs("div",{style:{display:"flex",flexDirection:"column",justifyContent:"flex-start"},children:[S.jsx(Er,{children:h("movement"===t?"tutorial_movement_title":"inventory"===t?"tutorial_inventory_title":"tutorial_car_title")}),S.jsx(Pr,{children:h("movement"===t?"tutorial_movement_desc":"inventory"===t?"tutorial_inventory_desc":"tutorial_car_desc")})]})]}),S.jsx(zr,{}),S.jsx(Rr,{children:j.map(e=>S.jsxs($r,{done:n[e.key],children:[S.jsx(Dr,{checked:n[e.key],children:n[e.key]&&S.jsx(q,{})}),e.label]},e.key))}),S.jsx(zr,{style:{margin:"1.6rem 0"}}),S.jsxs("div",{style:{display:"flex",alignItems:"center",justifyContent:"center",gap:"12px",width:"100%"},children:[S.jsx(Ir,{style:{width:"3.2rem",height:"3.2rem",color:"var(--main-200, #A7F1FA)",fontSize:"1.4rem",fontWeight:600,lineHeight:"2rem"},children:"H"}),S.jsx("div",{style:{display:"flex",flexDirection:"column",justifyContent:"flex-start"},children:S.jsx(Er,{style:{color:"#FFF",fontSize:"1.4rem",fontWeight:500,lineHeight:"2rem"},children:h("tutorial_cancel")})})]})]}),N.length>0&&S.jsxs(Mr,{children:[S.jsx(Fr,{style:{justifyContent:"center",marginBottom:"0.2rem",gap:"0"},children:1===N.length?S.jsx(Nr,{style:{fontSize:"2rem",minWidth:70,height:70},active:!!i[C(N[0])],onMouseDown:()=>a(e=>({...e,[C(N[0])]:!0})),onMouseUp:()=>a(e=>({...e,[C(N[0])]:!1})),onMouseLeave:()=>a(e=>({...e,[C(N[0])]:!1})),children:N[0]}):null}),4===N.length&&"WASD"===N.join("")?S.jsxs("div",{style:{display:"flex",flexDirection:"column",alignItems:"center",gap:"0.5rem"},children:[S.jsx(Fr,{style:{justifyContent:"center",gap:"2.2rem"},children:S.jsx(Nr,{active:!!i.w,onMouseDown:()=>a(e=>({...e,w:!0})),onMouseUp:()=>a(e=>({...e,w:!1})),onMouseLeave:()=>a(e=>({...e,w:!1})),children:"W"},"W")}),S.jsx(Fr,{style:{justifyContent:"center",gap:"2.2rem"},children:["A","S","D"].map(e=>S.jsx(Nr,{active:!!i[e.toLowerCase()],onMouseDown:()=>a(t=>({...t,[e.toLowerCase()]:!0})),onMouseUp:()=>a(t=>({...t,[e.toLowerCase()]:!1})),onMouseLeave:()=>a(t=>({...t,[e.toLowerCase()]:!1})),children:e},e))})]}):null,N.length>1&&!(4===N.length&&"WASD"===N.join(""))&&S.jsx(Fr,{children:N.map(e=>S.jsx(Nr,{active:!!i[C(e)],onMouseDown:()=>a(t=>({...t,[C(e)]:!0})),onMouseUp:()=>a(t=>({...t,[C(e)]:!1})),onMouseLeave:()=>a(t=>({...t,[C(e)]:!1})),children:e},e))})]}),z()&&S.jsx("div",{style:{position:"fixed",top:10,right:10,zIndex:9999},children:S.jsxs("button",{onClick:()=>r("movement"===t?"car":"car"===t?"inventory":"movement"),style:{padding:8,background:"#0DC8E7",color:"#222",border:0,borderRadius:6,fontWeight:600},children:["Alternar para tutorial: ","movement"===t?"Carro":"car"===t?"Inventário":"Movimento"]})})]}):null}const Tr=e=>S.jsxs("svg",{xmlns:"http://www.w3.org/2000/svg",width:"30",height:"38",fill:"none",viewBox:"0 0 30 38",children:[S.jsx("path",{fill:"var(--main-200)",d:"M11.675 11.962c1.798 0 3.257-1.48 3.257-3.306S13.473 5.35 11.675 5.35 8.418 6.83 8.418 8.656s1.458 3.306 3.257 3.306"}),S.jsx("path",{fill:"var(--main-200)",d:"M29.68 29.462c-1.687-3.004-4.216-5.054-7.322-6.345-.192-3.91-2.064-7.59-5.07-10.074-1.525-1.262-3.63-1.502-5.117.028a3 3 0 0 0-.256.3c-3.065-1.773-6.44-3.1-9.556-4.174-2.364-.814-3.37 2.972-1.027 3.78 3.528 1.214 7.406 2.788 10.634 5.07q.11.114.232.22c1.85 1.528 2.999 3.345 2.935 5.805-.01.401.035.765.121 1.099a29 29 0 0 1-.862 3.755c-1.141-1.197-2.204-2.463-3.088-3.886-1.655-2.664-5.832-.207-4.167 2.471 1.775 2.857 4.089 5.224 6.522 7.498 1.023.956 3.155 1.03 3.79-.496.954-2.293 1.715-4.603 2.228-6.985.156-.039.308-.091.458-.147q.243.17.545.288a9.15 9.15 0 0 1 3.86 2.83c-1.111 1.177-2.33 2.226-3.793 2.981-2.773 1.434-.33 5.66 2.435 4.229 2.415-1.248 4.393-3.19 6.118-5.281.714-.86.953-1.944.38-2.966M9.644 4.848c.455-.17.944-.512 1.457-.512 1.153 0 2.198.472 2.96 1.235a138 138 0 0 1-1.43-4.21C11.867-1.031 8.14-.006 8.91 2.405c.235.736.487 1.712.735 2.444"})]}),Or=e=>S.jsxs("svg",{xmlns:"http://www.w3.org/2000/svg",width:"24",height:"38",fill:"none",viewBox:"0 0 24 38",children:[S.jsx("path",{fill:"var(--main-200)",d:"M15.528 10.488a5.244 5.244 0 1 0 0-10.488 5.244 5.244 0 0 0 0 10.488M18.732 33.742l.58.581a1.86 1.86 0 0 0 2.637.006c.56-.557.69-1.38.393-2.064a3.5 3.5 0 0 1-.664.344zM12.19 14.658a1.864 1.864 0 1 0-3.668.674l1.732 9.43q.006.02.01.04l5.423.595-1.87-1.878z"}),S.jsx("path",{fill:"var(--main-200)",d:"m8.196 30.975-3.62 1.392a2.914 2.914 0 0 0 2.091 5.438l14.819-5.696a2.914 2.914 0 0 0-.727-5.615L9.447 25.25l-.294-.032q.193-.606.42-1.205l-1.578-8.586a2.403 2.403 0 0 1 2.366-2.835c1.156 0 2.147.828 2.356 1.968l.394 2.144c1.259-2.032 1.192-4.893-.557-5.922-1.768-1.04-4.84-.821-6.933 2.12C2.768 16.961 1.573 19.8.684 24.935c-.365 3.806 1.993 4.904 4.049 5.483.504.142.944.253 1.331.291q.104.026.213.045c.06.01.12.023.181.03z"})]}),Br=e=>S.jsx("svg",{xmlns:"http://www.w3.org/2000/svg",width:"28",height:"38",fill:"none",viewBox:"0 0 28 38",children:S.jsx("path",{fill:"var(--main-200)",d:"M27.526 8.746a.77.77 0 0 0-.835.168c-3.075 3.06-6.065 1.572-9.522-.145-3.098-1.534-6.555-3.243-9.99-.928V5.848a2.68 2.68 0 0 0 1.916-2.56A2.686 2.686 0 0 0 6.412.603 2.686 2.686 0 0 0 3.73 3.287c0 1.211.812 2.223 1.916 2.56v26.129C3.138 32.267.938 33.946.05 36.36a.75.75 0 0 0 .092.706c.138.206.375.33.628.33h11.294a.77.77 0 0 0 .72-1.035 6.83 6.83 0 0 0-5.604-4.386v-8.94c2.998-2.767 5.926-1.326 9.307.353 2.001.99 4.163 2.063 6.371 2.063 1.626 0 3.282-.583 4.915-2.209a.77.77 0 0 0 .23-.544V9.46a.77.77 0 0 0-.476-.713M7.18 20.023V10.84c.95.713 1.54 1.54 1.794 2.507.513 2.008-.468 4.385-1.794 6.677"})}),Wr=e=>S.jsx("svg",{xmlns:"http://www.w3.org/2000/svg",width:"26",height:"34",fill:"none",viewBox:"0 0 26 34",children:S.jsx("path",{fill:"var(--main-200)",d:"m15.335 28.34 1.378-2.239c.31-.495.765-.883 1.322-1.12a12.925 12.925 0 0 0 7.903-11.919c0-3.555-1.485-6.991-4.078-9.427A12.83 12.83 0 0 0 12.173.153C5.575.563.254 6.071.068 12.686c-.152 5.377 2.948 10.203 7.903 12.296a2.82 2.82 0 0 1 1.317 1.12l1.378 2.238C7.403 28.587 4 29.409 4 31.063c0 1.935 4.663 2.812 9 2.812s9-.877 9-2.812c0-1.654-3.403-2.476-6.665-2.723M5.125 13.063c0-4.343 3.533-7.876 7.875-7.876s7.875 3.533 7.875 7.876c0 4.342-3.532 7.874-7.875 7.874-4.342 0-7.875-3.532-7.875-7.875M13 32.75c-5.197 0-7.875-1.181-7.875-1.687 0-.383 1.856-1.407 6.21-1.637l1.187 1.929c.101.169.281.27.478.27a.55.55 0 0 0 .478-.27l1.187-1.93c4.354.231 6.21 1.255 6.21 1.637 0 .507-2.677 1.688-7.875 1.688"})}),Hr=e=>S.jsx("svg",{xmlns:"http://www.w3.org/2000/svg",width:"28",height:"32",fill:"none",viewBox:"0 0 28 32",children:S.jsx("path",{fill:"var(--main-200)",d:"M13.919 0c.861 0 1.688.337 2.297.937s.951 1.414.951 2.263c0 1.776-1.445 3.2-3.248 3.2a3.27 3.27 0 0 1-2.297-.937A3.18 3.18 0 0 1 10.67 3.2c0-.849.342-1.663.95-2.263.61-.6 1.436-.937 2.298-.937m.633 20.464a56 56 0 0 1 6.903.4c.097-4.352-.293-8.192-1.04-9.664a4.4 4.4 0 0 0-.812-1.12L6.497 21.152c2.208-.352 4.986-.688 8.055-.688M6.545 24c.211 2.784.634 5.6 1.316 8h3.362c-.471-1.408-.812-3.056-1.072-4.8 0 0 3.768-.704 7.536 0-.26 1.744-.601 3.392-1.072 4.8h3.362c.714-2.48 1.137-5.424 1.348-8.336a58 58 0 0 0-6.773-.4c-3.134 0-5.863.336-8.007.736M13.92 8s-4.873 0-6.497 3.2c-.552 1.088-.91 3.44-1.023 6.336l10.638-8.992C15.43 8 13.92 8 13.92 8m10.67-2.128-1.851-2.128-5.7 4.816c.892.304 1.834.784 2.565 1.52zM28 22.128c-.146-.048-2.485-.8-6.545-1.264a56 56 0 0 1-.13 2.8c3.654.448 5.75 1.136 5.782 1.136zM6.4 17.536 0 22.944l1.445 2.368c.033-.016 1.917-.736 5.1-1.312a55 55 0 0 1-.146-6.464"})}),Gr=e=>S.jsx("svg",{xmlns:"http://www.w3.org/2000/svg",width:"28",height:"29",fill:"none",viewBox:"0 0 28 29",children:S.jsx("path",{fill:"var(--main-200)",d:"M19.907 0c1.126 0 2.22.38 3.109 1.079a5.1 5.1 0 0 1 1.793 2.778l.598 2.414h1.42c.282 0 .555.103.767.29s.35.445.389.726l.01.16c0 .284-.101.559-.287.773a1.16 1.16 0 0 1-.72.392l-.159.011h-.833l.323 1.295c.514.315.939.758 1.234 1.286a3.55 3.55 0 0 1 .449 1.73v13.322c0 .728-.287 1.426-.797 1.94a2.7 2.7 0 0 1-1.925.804H22.94a2.7 2.7 0 0 1-1.924-.804 2.76 2.76 0 0 1-.797-1.94l-.002-1.955H7.782v1.955c0 .728-.286 1.426-.797 1.94A2.7 2.7 0 0 1 5.061 29H2.72a2.7 2.7 0 0 1-1.924-.804A2.76 2.76 0 0 1 0 26.256V12.935c0-1.278.673-2.398 1.683-3.015l.322-1.297h-.839c-.281 0-.554-.103-.766-.29a1.18 1.18 0 0 1-.39-.726L0 7.447c0-.284.102-.559.287-.773.186-.214.442-.353.72-.392l.16-.01h1.42l.6-2.412A5.1 5.1 0 0 1 4.98 1.08 5.03 5.03 0 0 1 8.09 0zM5.447 24.301H2.332l.002 1.955a.39.39 0 0 0 .389.392H5.06a.387.387 0 0 0 .388-.392zm20.219 0h-3.119l.002 1.955a.39.39 0 0 0 .389.392h2.339a.39.39 0 0 0 .389-.392zm-8.946-7.055h-5.446l-.159.011c-.28.039-.535.178-.72.392a1.18 1.18 0 0 0 0 1.546c.185.214.44.353.72.392l.159.01h5.446l.157-.01c.293-.04.56-.192.746-.423a1.183 1.183 0 0 0-.108-1.6 1.16 1.16 0 0 0-.795-.318m5.053-3.136a1.55 1.55 0 0 0-1.1.46 1.574 1.574 0 0 0 0 2.217 1.55 1.55 0 0 0 2.2 0 1.574 1.574 0 0 0 0-2.217 1.55 1.55 0 0 0-1.1-.46m-15.552 0c-.413 0-.808.166-1.1.46a1.574 1.574 0 0 0 0 2.217 1.55 1.55 0 0 0 2.2 0 1.574 1.574 0 0 0 0-2.217 1.55 1.55 0 0 0-1.1-.46M19.907 2.352H8.089c-.607 0-1.197.204-1.676.581a2.75 2.75 0 0 0-.965 1.498L4.216 9.407h19.568l-1.238-4.98a2.75 2.75 0 0 0-.966-1.495 2.7 2.7 0 0 0-1.675-.58"})}),Vr=Cr.div`
  position: absolute;
  background: var(--background-solid);
  color: #fff;
  border-radius: 10px;
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.2);
  padding: 1.8rem 1.6rem;
  min-width: 340px;
  z-index: 10;
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: flex-start;
  opacity: 0; /* Inicialmente invisível */
  transform: translateY(-10px); /* Move para cima */
  transition: opacity 0.3s ease, transform 0.3s ease; /* Animação de opacidade e transformação */
  min-width: 38.3rem;

  &.visible {
    opacity: 1; /* Visível */
    transform: translateY(0); /* Posição original */
  }

  &::after {
    content: '';
    position: absolute;
    top: 100%; /* Posição abaixo do tooltip */
    left: 50%;
    margin-left: -15px; /* Centraliza a ponta */
    border-width: 15px; /* Tamanho da ponta */
    border-style: solid;
    border-color: var(--background-solid) transparent transparent transparent; /* Cores da ponta */
  }
`,Ur=Cr.div`
  color: var(--white, #FFF);

  /* h4 */
  font-family: Inter;
  font-size: 2rem;
  font-style: normal;
  font-weight: 600;
  line-height: 2.8rem; /* 140% */
  letter-spacing: -0.01rem;
`,Yr=Cr.div`
  color: var(--white-opacity-500, rgba(255, 255, 255, 0.50));

  /* detail */
  font-family: Inter;
  font-size: 1.2rem;
  font-style: normal;
  font-weight: 500;
  line-height: 2rem; /* 166.667% */
`,qr=Cr.div`
  border-radius: var(--radius-md, 0.8rem);
  border: 1px solid var(--main-500, #0DC8E7);
  background: var(--main-950, #0A3242);
  // padding: 8px; // Padding around the icon
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 8px; // Space between icon and title
  display: flex;
  width: 5rem;
  height: 5rem;
  padding: 1.1rem 1.5rem;
  align-items: center;
  gap: 1rem;
  flex-shrink: 0;
`;Cr.img`
  width: 24px; // Adjust size as needed
  height: 24px; // Adjust size as needed
`;const Xr=({title:t,description:r,position:n,style:o,image:i})=>{const[a,s]=e.useState(!0);return S.jsxs(Vr,{style:{...o,top:n.top,left:n.left,zIndex:n.zIndex,transform:n.transform},className:a?"visible":"",children:[S.jsx(qr,{children:"jump"===i&&S.jsx(Tr,{})||"crounch"===i&&S.jsx(Or,{})||"flag"===i&&S.jsx(Br,{})||"point"===i&&S.jsx(Wr,{})||"belt"===i&&S.jsx(Hr,{})||"car"===i&&S.jsx(Gr,{})}),S.jsxs("div",{style:{display:"flex",flexDirection:"column",alignItems:"flex-start",justifyContent:"flex-start"},children:[S.jsx(Ur,{children:t}),S.jsx(Yr,{children:r})]})]})},Jr=e.createContext(void 0),Kr=({children:t})=>{const[r,n]=e.useState({title:"Tutorial",description:"Tutorial",image:"jump"});return S.jsx(Jr.Provider,{value:{tooltipData:r,setTooltipData:n},children:t})},Zr=()=>{const t=e.useContext(Jr);if(!t)throw new Error("useTooltip must be used within a TooltipProvider");return t},Qr=()=>{const{tooltipData:e}=Zr();return S.jsx("div",{children:e&&S.jsx(Xr,{title:e.title,description:e.description,image:e.image,position:{top:"50%",left:"50%",zIndex:1e3,transform:"translate(-50%, -60%)"},style:{position:"fixed",top:"50%",left:"50%",transform:"translate(-50%, -60%)",zIndex:1e3}})})};function en(){const[t,r]=e.useState("cidadenobre"),{setVisible:s}=M(e=>e),c=n(),{setTooltipData:l}=Zr();return e.useEffect(()=>{p("getCityName",{},"Maresia").then(e=>{r(e)}),p("Init")},[]),H("getCityName",e=>{r(e)}),e.useEffect(()=>{(async()=>{try{const e=document.createElement("link");e.rel="stylesheet",e.href=`https://santaimagens.roleplayrp.com/img/themes/${t}.css`,document.head.appendChild(e)}catch(e){}})()},[t]),H("setVisible",async e=>{s(e),c("/start")}),H("showTooltip",e=>{s(!0),l(e),c("/tutorial")}),S.jsx(G,{children:S.jsxs(o,{children:[S.jsx(i,{path:"/",element:S.jsx(a,{to:"/start"})}),S.jsx(i,{path:"/start",element:S.jsx(Lr,{})}),S.jsx(i,{path:"/tutorial",element:S.jsx(Qr,{})})]})})}const tn=e.createContext({url:"",isReady:!1});function rn({children:t}){const[r,n]=e.useState({url:""}),[o,i]=e.useState(!!z());return e.useEffect(()=>{(async()=>{try{const e=(await p("getServerHost",{})).replace(/^(https?:\/\/)/,"");n({url:e}),i(!0)}catch(e){n({url:"api.santagroup.com.br"}),i(!0)}})()},[]),S.jsx(tn.Provider,{value:{...r,isReady:o},children:t})}if(z()){const e=document.getElementById("root");e.style.backgroundImage="url('https://files.catbox.moe/5te7js.png')",e.style.backgroundSize="cover",e.style.backgroundRepeat="no-repeat",e.style.backgroundPosition="center",e.style.height="100vh"}C.createRoot(document.getElementById("root")).render(S.jsx(r.StrictMode,{children:S.jsx(s,{children:S.jsx(f,{customTheme:{borders:{main:{100:"1px solid rgba(255, 255, 255, 0.1)",200:"1px solid rgba(255, 255, 255, 0.2)",300:"1px solid rgba(255, 255, 255, 0.3)"}},colors:{main:{50:"#ff8f0026",100:"#ff8f0040",200:"#ff8f0080",300:"#ff8f00cc",400:"#ff8f00ff",500:"#ff8f00ff",600:"#ff8f00ff",700:"#ff8f00ff",800:"#ff8f00ff",900:"#ff8f00e6"}},logo:"https://example.com/logo.png",smallLogo:"https://example.com/small-logo.png",isFromHookCache:!1,images:{background:"https://example.com/background.jpg"},tag:"default"},children:S.jsx(h,{children:S.jsx(rn,{children:S.jsx(Kr,{children:S.jsx(en,{})})})})})})}));
