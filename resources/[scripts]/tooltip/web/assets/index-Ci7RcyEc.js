import{r as e,a as t,R as r,u as n,b as o,c as i,N as s,H as a}from"./react-vendor-gEOpCwnQ.js";import{i as c,c as l,f as u,u as d,C as p,a as f}from"./utils-vendor-2zoz1-z5.js";!function(){const e=document.createElement("link").relList;if(!(e&&e.supports&&e.supports("modulepreload"))){for(const e of document.querySelectorAll('link[rel="modulepreload"]'))t(e);new MutationObserver((e=>{for(const r of e)if("childList"===r.type)for(const e of r.addedNodes)"LINK"===e.tagName&&"modulepreload"===e.rel&&t(e)})).observe(document,{childList:!0,subtree:!0})}function t(e){if(e.ep)return;e.ep=!0;const t=function(e){const t={};return e.integrity&&(t.integrity=e.integrity),e.referrerPolicy&&(t.referrerPolicy=e.referrerPolicy),"use-credentials"===e.crossOrigin?t.credentials="include":"anonymous"===e.crossOrigin?t.credentials="omit":t.credentials="same-origin",t}(e);fetch(e.href,t)}}();var h={exports:{}},m={},g=e,v=Symbol.for("react.element"),y=Symbol.for("react.fragment"),x=Object.prototype.hasOwnProperty,b=g.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED.ReactCurrentOwner,w={key:!0,ref:!0,__self:!0,__source:!0};function j(e,t,r){var n,o={},i=null,s=null;for(n in void 0!==r&&(i=""+r),void 0!==t.key&&(i=""+t.key),void 0!==t.ref&&(s=t.ref),t)x.call(t,n)&&!w.hasOwnProperty(n)&&(o[n]=t[n]);if(e&&e.defaultProps)for(n in t=e.defaultProps)void 0===o[n]&&(o[n]=t[n]);return{$$typeof:v,type:e,key:i,ref:s,props:o,_owner:b.current}}m.Fragment=y,m.jsx=j,m.jsxs=j,h.exports=m;var k=h.exports,S={},C=t;S.createRoot=C.createRoot,S.hydrateRoot=C.hydrateRoot;const _=e.createContext({}),A=e.createContext({transformPagePoint:e=>e,isStatic:!1,reducedMotion:"never"}),E=e.createContext(null),I=c?e.useLayoutEffect:e.useEffect;function P(t){const r=e.useRef(null);return null===r.current&&(r.current=t()),r.current}const R=()=>!window.invokeNative,z=window.GetParentResourceName?window.GetParentResourceName():"zs-boilerplate";async function $({path:e,payload:t,delay:r,mockData:n}){const o=R();if(o&&n)return r&&await(e=>new Promise((t=>{setTimeout((()=>{t(!0)}),e)})))(r),n;try{const i=await fetch(`https://${z}/${e}`,{method:"post",headers:{"Content-Type":"application/json; charset=UTF-8"},body:JSON.stringify(t)}),_txt=await i.text();return _txt?JSON.parse(_txt):{}}catch(_e){return{}}}const M=l()(((e,t)=>({visible:R(),canCloseUi:!0,setVisible:t=>e({visible:t}),setCanCloseUi:t=>e({canCloseUi:t}),fetchHideFrame:async()=>{const{visible:r}=t();if(!r)return;await $({path:"hideFrame",mockData:!0})&&e({visible:!1})}})));class D extends e.Component{getSnapshotBeforeUpdate(e){const t=this.props.childRef.current;if(t&&e.isPresent&&!this.props.isPresent){const e=t.offsetParent,r=e instanceof HTMLElement&&e.offsetWidth||0,n=this.props.sizeRef.current;n.height=t.offsetHeight||0,n.width=t.offsetWidth||0,n.top=t.offsetTop,n.left=t.offsetLeft,n.right=r-n.width-n.left}return null}componentDidUpdate(){}render(){return this.props.children}}function N({children:t,isPresent:r,anchorX:n}){const o=e.useId(),i=e.useRef(null),s=e.useRef({width:0,height:0,top:0,left:0,right:0}),{nonce:a}=e.useContext(A);return e.useInsertionEffect((()=>{const{width:e,height:t,top:c,left:l,right:u}=s.current;if(r||!i.current||!e||!t)return;const d="left"===n?`left: ${l}`:`right: ${u}`;i.current.dataset.motionPopId=o;const p=document.createElement("style");return a&&(p.nonce=a),document.head.appendChild(p),p.sheet&&p.sheet.insertRule(`\n          [data-motion-pop-id="${o}"] {\n            position: absolute !important;\n            width: ${e}px !important;\n            height: ${t}px !important;\n            ${d}px !important;\n            top: ${c}px !important;\n          }\n        `),()=>{document.head.removeChild(p)}}),[r]),k.jsx(D,{isPresent:r,childRef:i,sizeRef:s,children:e.cloneElement(t,{ref:i})})}const L=({children:t,initial:r,isPresent:n,onExitComplete:o,custom:i,presenceAffectsLayout:s,mode:a,anchorX:c})=>{const l=P(F),u=e.useId();let d=!0,p=e.useMemo((()=>(d=!1,{id:u,initial:r,isPresent:n,custom:i,onExitComplete:e=>{l.set(e,!0);for(const t of l.values())if(!t)return;o&&o()},register:e=>(l.set(e,!1),()=>l.delete(e))})),[n,l,o]);return s&&d&&(p={...p}),e.useMemo((()=>{l.forEach(((e,t)=>l.set(t,!1)))}),[n]),e.useEffect((()=>{!n&&!l.size&&o&&o()}),[n]),"popLayout"===a&&(t=k.jsx(N,{isPresent:n,anchorX:c,children:t})),k.jsx(E.Provider,{value:p,children:t})};function F(){return new Map}const T=e=>e.key||"";function O(t){const r=[];return e.Children.forEach(t,(t=>{e.isValidElement(t)&&r.push(t)})),r}const B=({children:t,custom:r,initial:n=!0,onExitComplete:o,presenceAffectsLayout:i=!0,mode:s="sync",propagate:a=!1,anchorX:c="left"})=>{const[l,u]=function(t=!0){const r=e.useContext(E);if(null===r)return[!0,null];const{isPresent:n,onExitComplete:o,register:i}=r,s=e.useId();e.useEffect((()=>{if(t)return i(s)}),[t]);const a=e.useCallback((()=>t&&o&&o(s)),[s,o,t]);return!n&&o?[!1,a]:[!0]}(a),d=e.useMemo((()=>O(t)),[t]),p=a&&!l?[]:d.map(T),f=e.useRef(!0),h=e.useRef(d),m=P((()=>new Map)),[g,v]=e.useState(d),[y,x]=e.useState(d);I((()=>{f.current=!1,h.current=d;for(let e=0;e<y.length;e++){const t=T(y[e]);p.includes(t)?m.delete(t):!0!==m.get(t)&&m.set(t,!1)}}),[y,p.length,p.join("-")]);const b=[];if(d!==g){let e=[...d];for(let t=0;t<y.length;t++){const r=y[t],n=T(r);p.includes(n)||(e.splice(t,0,r),b.push(r))}return"wait"===s&&b.length&&(e=b),x(O(e)),v(d),null}const{forceRender:w}=e.useContext(_);return k.jsx(k.Fragment,{children:y.map((e=>{const t=T(e),g=!(a&&!l)&&(d===y||p.includes(t));return k.jsx(L,{isPresent:g,initial:!(f.current&&!n)&&void 0,custom:r,presenceAffectsLayout:i,mode:s,onExitComplete:g?void 0:()=>{if(!m.has(t))return;m.set(t,!0);let e=!0;m.forEach((t=>{t||(e=!1)})),e&&(null==w||w(),x(h.current),a&&(null==u||u()),o&&o())},anchorX:c,children:e},t)}))})},W=(t,r)=>{e.useEffect((()=>{const e=e=>{e.key===t&&r()};return window.addEventListener("keydown",e),()=>window.removeEventListener("keydown",e)}),[r,t])};function H(t,r){e.useEffect((()=>{const e=e=>{const{action:n,data:o}=e.data;n===t&&r(o)};return R()||window.addEventListener("message",e),()=>{R()||window.removeEventListener("message",e)}}),[t,r])}function G({children:e}){const{visible:t,setVisible:r}=M((e=>e));return W("Escape",(async()=>{u("closeNui",{},!0),r(!1)})),H("setVisible",(async e=>{r(e)})),k.jsx(B,{children:t&&e})}const V=e=>k.jsx("svg",{xmlns:"http://www.w3.org/2000/svg",width:"32",height:"32",fill:"none",viewBox:"0 0 32 32",...e,children:k.jsx("path",{fill:"#A7F1FA",d:"M16 2.667a5 5 0 0 0-4.981 4.565 10.67 10.67 0 0 0-5.686 9.435v2h21.334v-2a10.67 10.67 0 0 0-5.686-9.435A5 5 0 0 0 16 2.667m10.667 18.285h-14V23a1 1 0 0 1-2 0v-2.048H5.333V25a4.334 4.334 0 0 0 4.334 4.333h12.666A4.334 4.334 0 0 0 26.667 25zM16 6c-.93 0-1.832.12-2.693.343a3 3 0 0 1 5.386 0A10.7 10.7 0 0 0 16 6m-5.333 7.89a3.22 3.22 0 0 1 3.222-3.223h4.222a3.223 3.223 0 0 1 3.222 3.222c0 1.164-.945 2.111-2.11 2.111h-6.446a2.11 2.11 0 0 1-2.11-2.11m3.222-1.223a1.223 1.223 0 0 0-1.222 1.222c0 .062.049.111.11.111h6.446a.11.11 0 0 0 .11-.11 1.223 1.223 0 0 0-1.222-1.223z"})}),U=e=>k.jsx("svg",{xmlns:"http://www.w3.org/2000/svg",width:"32",height:"32",fill:"none",viewBox:"0 0 32 32",...e,children:k.jsx("path",{fill:"#A7F1FA",d:"m23.552 13-.27-.096-2.27-4.256A5 5 0 0 0 16.6 6h-5.716A5 5 0 0 0 6.14 9.42l-1.082 3.246A5 5 0 0 0 2 17.274V19.5c0 1.42.846 2.64 2.06 3.19a4 4 0 0 0 7.814.31h8.252a4 4 0 0 0 7.814-.31A3.5 3.5 0 0 0 30 19.5v-.678a5 5 0 0 0-3.324-4.71l-3.02-1.074V13zM8.034 10.052A3 3 0 0 1 10.884 8H13v5H7.054zM21.066 13H15V8h1.6a3 3 0 0 1 2.648 1.588zM6 22a2 2 0 1 1 4 0 2 2 0 0 1-4 0m18-2a2 2 0 1 1 0 4 2 2 0 0 1 0-4"})}),Y=e=>k.jsxs("svg",{xmlns:"http://www.w3.org/2000/svg",width:"24",height:"28",fill:"none",viewBox:"0 0 24 28",...e,children:[k.jsx("path",{fill:"#A7F1FA",fillRule:"evenodd",d:"M7.344 19.646C3.029 20.252 0 21.675 0 23.333c0 2.21 5.373 4 12 4s12-1.79 12-4c0-1.658-3.029-3.081-7.344-3.687a4.667 4.667 0 0 1-9.312 0",clipRule:"evenodd",opacity:"0.4"}),k.jsx("path",{fill:"#A7F1FA",fillRule:"evenodd",d:"M12 6a2.667 2.667 0 1 0 0-5.333A2.667 2.667 0 0 0 12 6m5.333 5.333v1.334c0 .736-.597 1.333-1.333 1.333s-1.333.597-1.333 1.333v4a2.667 2.667 0 1 1-5.334 0v-4C9.333 14.597 8.736 14 8 14a1.333 1.333 0 0 1-1.333-1.333v-1.334a5.333 5.333 0 1 1 10.666 0",clipRule:"evenodd"})]}),q=e=>k.jsx("svg",{xmlns:"http://www.w3.org/2000/svg",width:"16",height:"16",fill:"none",viewBox:"0 0 16 16",children:k.jsx("path",{fill:"var(--main-200)",fillRule:"evenodd",d:"M8 14.25a6.25 6.25 0 1 0 0-12.5 6.25 6.25 0 0 0 0 12.5m2.87-7.837a.469.469 0 1 0-.74-.576l-2.504 3.22a.156.156 0 0 1-.228.02L5.814 7.652a.469.469 0 0 0-.628.696l1.585 1.426c.472.425 1.205.36 1.595-.141z",clipRule:"evenodd"})});var X=function(){return X=Object.assign||function(e){for(var t,r=1,n=arguments.length;r<n;r++)for(var o in t=arguments[r])Object.prototype.hasOwnProperty.call(t,o)&&(e[o]=t[o]);return e},X.apply(this,arguments)};function J(e,t,r){if(r||2===arguments.length)for(var n,o=0,i=t.length;o<i;o++)!n&&o in t||(n||(n=Array.prototype.slice.call(t,0,o)),n[o]=t[o]);return e.concat(n||Array.prototype.slice.call(t))}"function"==typeof SuppressedError&&SuppressedError;var K="-ms-",Z="-moz-",Q="-webkit-",ee="comm",te="rule",re="decl",ne="@keyframes",oe=Math.abs,ie=String.fromCharCode,se=Object.assign;function ae(e){return e.trim()}function ce(e,t){return(e=t.exec(e))?e[0]:e}function le(e,t,r){return e.replace(t,r)}function ue(e,t,r){return e.indexOf(t,r)}function de(e,t){return 0|e.charCodeAt(t)}function pe(e,t,r){return e.slice(t,r)}function fe(e){return e.length}function he(e){return e.length}function me(e,t){return t.push(e),e}function ge(e,t){return e.filter((function(e){return!ce(e,t)}))}var ve=1,ye=1,xe=0,be=0,we=0,je="";function ke(e,t,r,n,o,i,s,a){return{value:e,root:t,parent:r,type:n,props:o,children:i,line:ve,column:ye,length:s,return:"",siblings:a}}function Se(e,t){return se(ke("",null,null,"",null,null,0,e.siblings),e,{length:-e.length},t)}function Ce(e){for(;e.root;)e=Se(e.root,{children:[e]});me(e,e.siblings)}function _e(){return we=be<xe?de(je,be++):0,ye++,10===we&&(ye=1,ve++),we}function Ae(){return de(je,be)}function Ee(){return be}function Ie(e,t){return pe(je,e,t)}function Pe(e){switch(e){case 0:case 9:case 10:case 13:case 32:return 5;case 33:case 43:case 44:case 47:case 62:case 64:case 126:case 59:case 123:case 125:return 4;case 58:return 3;case 34:case 39:case 40:case 91:return 2;case 41:case 93:return 1}return 0}function Re(e){return ae(Ie(be-1,Me(91===e?e+2:40===e?e+1:e)))}function ze(e){for(;(we=Ae())&&we<33;)_e();return Pe(e)>2||Pe(we)>3?"":" "}function $e(e,t){for(;--t&&_e()&&!(we<48||we>102||we>57&&we<65||we>70&&we<97););return Ie(e,Ee()+(t<6&&32==Ae()&&32==_e()))}function Me(e){for(;_e();)switch(we){case e:return be;case 34:case 39:34!==e&&39!==e&&Me(we);break;case 40:41===e&&Me(e);break;case 92:_e()}return be}function De(e,t){for(;_e()&&e+we!==57&&(e+we!==84||47!==Ae()););return"/*"+Ie(t,be-1)+"*"+ie(47===e?e:_e())}function Ne(e){for(;!Pe(Ae());)_e();return Ie(e,be)}function Le(e){return function(e){return je="",e}(Fe("",null,null,null,[""],e=function(e){return ve=ye=1,xe=fe(je=e),be=0,[]}(e),0,[0],e))}function Fe(e,t,r,n,o,i,s,a,c){for(var l=0,u=0,d=s,p=0,f=0,h=0,m=1,g=1,v=1,y=0,x="",b=o,w=i,j=n,k=x;g;)switch(h=y,y=_e()){case 40:if(108!=h&&58==de(k,d-1)){-1!=ue(k+=le(Re(y),"&","&\f"),"&\f",oe(l?a[l-1]:0))&&(v=-1);break}case 34:case 39:case 91:k+=Re(y);break;case 9:case 10:case 13:case 32:k+=ze(h);break;case 92:k+=$e(Ee()-1,7);continue;case 47:switch(Ae()){case 42:case 47:me(Oe(De(_e(),Ee()),t,r,c),c);break;default:k+="/"}break;case 123*m:a[l++]=fe(k)*v;case 125*m:case 59:case 0:switch(y){case 0:case 125:g=0;case 59+u:-1==v&&(k=le(k,/\f/g,"")),f>0&&fe(k)-d&&me(f>32?Be(k+";",n,r,d-1,c):Be(le(k," ","")+";",n,r,d-2,c),c);break;case 59:k+=";";default:if(me(j=Te(k,t,r,l,u,o,a,x,b=[],w=[],d,i),i),123===y)if(0===u)Fe(k,t,j,j,b,i,d,a,w);else switch(99===p&&110===de(k,3)?100:p){case 100:case 108:case 109:case 115:Fe(e,j,j,n&&me(Te(e,j,j,0,0,o,a,x,o,b=[],d,w),w),o,w,d,a,n?b:w);break;default:Fe(k,j,j,j,[""],w,0,a,w)}}l=u=f=0,m=v=1,x=k="",d=s;break;case 58:d=1+fe(k),f=h;default:if(m<1)if(123==y)--m;else if(125==y&&0==m++&&125==(we=be>0?de(je,--be):0,ye--,10===we&&(ye=1,ve--),we))continue;switch(k+=ie(y),y*m){case 38:v=u>0?1:(k+="\f",-1);break;case 44:a[l++]=(fe(k)-1)*v,v=1;break;case 64:45===Ae()&&(k+=Re(_e())),p=Ae(),u=d=fe(x=k+=Ne(Ee())),y++;break;case 45:45===h&&2==fe(k)&&(m=0)}}return i}function Te(e,t,r,n,o,i,s,a,c,l,u,d){for(var p=o-1,f=0===o?i:[""],h=he(f),m=0,g=0,v=0;m<n;++m)for(var y=0,x=pe(e,p+1,p=oe(g=s[m])),b=e;y<h;++y)(b=ae(g>0?f[y]+" "+x:le(x,/&\f/g,f[y])))&&(c[v++]=b);return ke(e,t,r,0===o?te:a,c,l,u,d)}function Oe(e,t,r,n){return ke(e,t,r,ee,ie(we),pe(e,2,-2),0,n)}function Be(e,t,r,n,o){return ke(e,t,r,re,pe(e,0,n),pe(e,n+1,-1),n,o)}function We(e,t,r){switch(function(e,t){return 45^de(e,0)?(((t<<2^de(e,0))<<2^de(e,1))<<2^de(e,2))<<2^de(e,3):0}(e,t)){case 5103:return Q+"print-"+e+e;case 5737:case 4201:case 3177:case 3433:case 1641:case 4457:case 2921:case 5572:case 6356:case 5844:case 3191:case 6645:case 3005:case 6391:case 5879:case 5623:case 6135:case 4599:case 4855:case 4215:case 6389:case 5109:case 5365:case 5621:case 3829:return Q+e+e;case 4789:return Z+e+e;case 5349:case 4246:case 4810:case 6968:case 2756:return Q+e+Z+e+K+e+e;case 5936:switch(de(e,t+11)){case 114:return Q+e+K+le(e,/[svh]\w+-[tblr]{2}/,"tb")+e;case 108:return Q+e+K+le(e,/[svh]\w+-[tblr]{2}/,"tb-rl")+e;case 45:return Q+e+K+le(e,/[svh]\w+-[tblr]{2}/,"lr")+e}case 6828:case 4268:case 2903:return Q+e+K+e+e;case 6165:return Q+e+K+"flex-"+e+e;case 5187:return Q+e+le(e,/(\w+).+(:[^]+)/,Q+"box-$1$2"+K+"flex-$1$2")+e;case 5443:return Q+e+K+"flex-item-"+le(e,/flex-|-self/g,"")+(ce(e,/flex-|baseline/)?"":K+"grid-row-"+le(e,/flex-|-self/g,""))+e;case 4675:return Q+e+K+"flex-line-pack"+le(e,/align-content|flex-|-self/g,"")+e;case 5548:return Q+e+K+le(e,"shrink","negative")+e;case 5292:return Q+e+K+le(e,"basis","preferred-size")+e;case 6060:return Q+"box-"+le(e,"-grow","")+Q+e+K+le(e,"grow","positive")+e;case 4554:return Q+le(e,/([^-])(transform)/g,"$1"+Q+"$2")+e;case 6187:return le(le(le(e,/(zoom-|grab)/,Q+"$1"),/(image-set)/,Q+"$1"),e,"")+e;case 5495:case 3959:return le(e,/(image-set\([^]*)/,Q+"$1$`$1");case 4968:return le(le(e,/(.+:)(flex-)?(.*)/,Q+"box-pack:$3"+K+"flex-pack:$3"),/s.+-b[^;]+/,"justify")+Q+e+e;case 4200:if(!ce(e,/flex-|baseline/))return K+"grid-column-align"+pe(e,t)+e;break;case 2592:case 3360:return K+le(e,"template-","")+e;case 4384:case 3616:return r&&r.some((function(e,r){return t=r,ce(e.props,/grid-\w+-end/)}))?~ue(e+(r=r[t].value),"span",0)?e:K+le(e,"-start","")+e+K+"grid-row-span:"+(~ue(r,"span",0)?ce(r,/\d+/):+ce(r,/\d+/)-+ce(e,/\d+/))+";":K+le(e,"-start","")+e;case 4896:case 4128:return r&&r.some((function(e){return ce(e.props,/grid-\w+-start/)}))?e:K+le(le(e,"-end","-span"),"span ","")+e;case 4095:case 3583:case 4068:case 2532:return le(e,/(.+)-inline(.+)/,Q+"$1$2")+e;case 8116:case 7059:case 5753:case 5535:case 5445:case 5701:case 4933:case 4677:case 5533:case 5789:case 5021:case 4765:if(fe(e)-1-t>6)switch(de(e,t+1)){case 109:if(45!==de(e,t+4))break;case 102:return le(e,/(.+:)(.+)-([^]+)/,"$1"+Q+"$2-$3$1"+Z+(108==de(e,t+3)?"$3":"$2-$3"))+e;case 115:return~ue(e,"stretch",0)?We(le(e,"stretch","fill-available"),t,r)+e:e}break;case 5152:case 5920:return le(e,/(.+?):(\d+)(\s*\/\s*(span)?\s*(\d+))?(.*)/,(function(t,r,n,o,i,s,a){return K+r+":"+n+a+(o?K+r+"-span:"+(i?s:+s-+n)+a:"")+e}));case 4949:if(121===de(e,t+6))return le(e,":",":"+Q)+e;break;case 6444:switch(de(e,45===de(e,14)?18:11)){case 120:return le(e,/(.+:)([^;\s!]+)(;|(\s+)?!.+)?/,"$1"+Q+(45===de(e,14)?"inline-":"")+"box$3$1"+Q+"$2$3$1"+K+"$2box$3")+e;case 100:return le(e,":",":"+K)+e}break;case 5719:case 2647:case 2135:case 3927:case 2391:return le(e,"scroll-","scroll-snap-")+e}return e}function He(e,t){for(var r="",n=0;n<e.length;n++)r+=t(e[n],n,e,t)||"";return r}function Ge(e,t,r,n){switch(e.type){case"@layer":if(e.children.length)break;case"@import":case re:return e.return=e.return||e.value;case ee:return"";case ne:return e.return=e.value+"{"+He(e.children,n)+"}";case te:if(!fe(e.value=e.props.join(",")))return""}return fe(r=He(e.children,n))?e.return=e.value+"{"+r+"}":""}function Ve(e,t,r,n){if(e.length>-1&&!e.return)switch(e.type){case re:return void(e.return=We(e.value,e.length,r));case ne:return He([Se(e,{value:le(e.value,"@","@"+Q)})],n);case te:if(e.length)return function(e,t){return e.map(t).join("")}(r=e.props,(function(t){switch(ce(t,n=/(::plac\w+|:read-\w+)/)){case":read-only":case":read-write":Ce(Se(e,{props:[le(t,/:(read-\w+)/,":-moz-$1")]})),Ce(Se(e,{props:[t]})),se(e,{props:ge(r,n)});break;case"::placeholder":Ce(Se(e,{props:[le(t,/:(plac\w+)/,":"+Q+"input-$1")]})),Ce(Se(e,{props:[le(t,/:(plac\w+)/,":-moz-$1")]})),Ce(Se(e,{props:[le(t,/:(plac\w+)/,K+"input-$1")]})),Ce(Se(e,{props:[t]})),se(e,{props:ge(r,n)})}return""}))}}var Ue={animationIterationCount:1,aspectRatio:1,borderImageOutset:1,borderImageSlice:1,borderImageWidth:1,boxFlex:1,boxFlexGroup:1,boxOrdinalGroup:1,columnCount:1,columns:1,flex:1,flexGrow:1,flexPositive:1,flexShrink:1,flexNegative:1,flexOrder:1,gridRow:1,gridRowEnd:1,gridRowSpan:1,gridRowStart:1,gridColumn:1,gridColumnEnd:1,gridColumnSpan:1,gridColumnStart:1,msGridRow:1,msGridRowSpan:1,msGridColumn:1,msGridColumnSpan:1,fontWeight:1,lineHeight:1,opacity:1,order:1,orphans:1,tabSize:1,widows:1,zIndex:1,zoom:1,WebkitLineClamp:1,fillOpacity:1,floodOpacity:1,stopOpacity:1,strokeDasharray:1,strokeDashoffset:1,strokeMiterlimit:1,strokeOpacity:1,strokeWidth:1},Ye={},qe="undefined"!=typeof process&&void 0!==Ye&&(Ye.REACT_APP_SC_ATTR||Ye.SC_ATTR)||"data-styled",Xe="active",Je="data-styled-version",Ke="6.1.18",Ze="/*!sc*/\n",Qe="undefined"!=typeof window&&"undefined"!=typeof document,et=Boolean("boolean"==typeof SC_DISABLE_SPEEDY?SC_DISABLE_SPEEDY:"undefined"!=typeof process&&void 0!==Ye&&void 0!==Ye.REACT_APP_SC_DISABLE_SPEEDY&&""!==Ye.REACT_APP_SC_DISABLE_SPEEDY?"false"!==Ye.REACT_APP_SC_DISABLE_SPEEDY&&Ye.REACT_APP_SC_DISABLE_SPEEDY:"undefined"!=typeof process&&void 0!==Ye&&void 0!==Ye.SC_DISABLE_SPEEDY&&""!==Ye.SC_DISABLE_SPEEDY&&("false"!==Ye.SC_DISABLE_SPEEDY&&Ye.SC_DISABLE_SPEEDY)),tt=Object.freeze([]),rt=Object.freeze({});var nt=new Set(["a","abbr","address","area","article","aside","audio","b","base","bdi","bdo","big","blockquote","body","br","button","canvas","caption","cite","code","col","colgroup","data","datalist","dd","del","details","dfn","dialog","div","dl","dt","em","embed","fieldset","figcaption","figure","footer","form","h1","h2","h3","h4","h5","h6","header","hgroup","hr","html","i","iframe","img","input","ins","kbd","keygen","label","legend","li","link","main","map","mark","menu","menuitem","meta","meter","nav","noscript","object","ol","optgroup","option","output","p","param","picture","pre","progress","q","rp","rt","ruby","s","samp","script","section","select","small","source","span","strong","style","sub","summary","sup","table","tbody","td","textarea","tfoot","th","thead","time","tr","track","u","ul","use","var","video","wbr","circle","clipPath","defs","ellipse","foreignObject","g","image","line","linearGradient","marker","mask","path","pattern","polygon","polyline","radialGradient","rect","stop","svg","text","tspan"]),ot=/[!"#$%&'()*+,./:;<=>?@[\\\]^`{|}~-]+/g,it=/(^-|-$)/g;function st(e){return e.replace(ot,"-").replace(it,"")}var at=/(a)(d)/gi,ct=function(e){return String.fromCharCode(e+(e>25?39:97))};function lt(e){var t,r="";for(t=Math.abs(e);t>52;t=t/52|0)r=ct(t%52)+r;return(ct(t%52)+r).replace(at,"$1-$2")}var ut,dt=function(e,t){for(var r=t.length;r;)e=33*e^t.charCodeAt(--r);return e},pt=function(e){return dt(5381,e)};function ft(e){return"string"==typeof e&&!0}var ht="function"==typeof Symbol&&Symbol.for,mt=ht?Symbol.for("react.memo"):60115,gt=ht?Symbol.for("react.forward_ref"):60112,vt={childContextTypes:!0,contextType:!0,contextTypes:!0,defaultProps:!0,displayName:!0,getDefaultProps:!0,getDerivedStateFromError:!0,getDerivedStateFromProps:!0,mixins:!0,propTypes:!0,type:!0},yt={name:!0,length:!0,prototype:!0,caller:!0,callee:!0,arguments:!0,arity:!0},xt={$$typeof:!0,compare:!0,defaultProps:!0,displayName:!0,propTypes:!0,type:!0},bt=((ut={})[gt]={$$typeof:!0,render:!0,defaultProps:!0,displayName:!0,propTypes:!0},ut[mt]=xt,ut);function wt(e){return("type"in(t=e)&&t.type.$$typeof)===mt?xt:"$$typeof"in e?bt[e.$$typeof]:vt;var t}var jt=Object.defineProperty,kt=Object.getOwnPropertyNames,St=Object.getOwnPropertySymbols,Ct=Object.getOwnPropertyDescriptor,_t=Object.getPrototypeOf,At=Object.prototype;function Et(e,t,r){if("string"!=typeof t){if(At){var n=_t(t);n&&n!==At&&Et(e,n,r)}var o=kt(t);St&&(o=o.concat(St(t)));for(var i=wt(e),s=wt(t),a=0;a<o.length;++a){var c=o[a];if(!(c in yt||r&&r[c]||s&&c in s||i&&c in i)){var l=Ct(t,c);try{jt(e,c,l)}catch(u){}}}}return e}function It(e){return"function"==typeof e}function Pt(e){return"object"==typeof e&&"styledComponentId"in e}function Rt(e,t){return e&&t?"".concat(e," ").concat(t):e||t||""}function zt(e,t){if(0===e.length)return"";for(var r=e[0],n=1;n<e.length;n++)r+=e[n];return r}function $t(e){return null!==e&&"object"==typeof e&&e.constructor.name===Object.name&&!("props"in e&&e.$$typeof)}function Mt(e,t,r){if(void 0===r&&(r=!1),!r&&!$t(e)&&!Array.isArray(e))return t;if(Array.isArray(t))for(var n=0;n<t.length;n++)e[n]=Mt(e[n],t[n]);else if($t(t))for(var n in t)e[n]=Mt(e[n],t[n]);return e}function Dt(e,t){Object.defineProperty(e,"toString",{value:t})}function Nt(e){for(var t=[],r=1;r<arguments.length;r++)t[r-1]=arguments[r];return new Error("An error occurred. See https://github.com/styled-components/styled-components/blob/main/packages/styled-components/src/utils/errors.md#".concat(e," for more information.").concat(t.length>0?" Args: ".concat(t.join(", ")):""))}var Lt=function(){function e(e){this.groupSizes=new Uint32Array(512),this.length=512,this.tag=e}return e.prototype.indexOfGroup=function(e){for(var t=0,r=0;r<e;r++)t+=this.groupSizes[r];return t},e.prototype.insertRules=function(e,t){if(e>=this.groupSizes.length){for(var r=this.groupSizes,n=r.length,o=n;e>=o;)if((o<<=1)<0)throw Nt(16,"".concat(e));this.groupSizes=new Uint32Array(o),this.groupSizes.set(r),this.length=o;for(var i=n;i<o;i++)this.groupSizes[i]=0}for(var s=this.indexOfGroup(e+1),a=(i=0,t.length);i<a;i++)this.tag.insertRule(s,t[i])&&(this.groupSizes[e]++,s++)},e.prototype.clearGroup=function(e){if(e<this.length){var t=this.groupSizes[e],r=this.indexOfGroup(e),n=r+t;this.groupSizes[e]=0;for(var o=r;o<n;o++)this.tag.deleteRule(r)}},e.prototype.getGroup=function(e){var t="";if(e>=this.length||0===this.groupSizes[e])return t;for(var r=this.groupSizes[e],n=this.indexOfGroup(e),o=n+r,i=n;i<o;i++)t+="".concat(this.tag.getRule(i)).concat(Ze);return t},e}(),Ft=new Map,Tt=new Map,Ot=1,Bt=function(e){if(Ft.has(e))return Ft.get(e);for(;Tt.has(Ot);)Ot++;var t=Ot++;return Ft.set(e,t),Tt.set(t,e),t},Wt=function(e,t){Ot=t+1,Ft.set(e,t),Tt.set(t,e)},Ht="style[".concat(qe,"][").concat(Je,'="').concat(Ke,'"]'),Gt=new RegExp("^".concat(qe,'\\.g(\\d+)\\[id="([\\w\\d-]+)"\\].*?"([^"]*)')),Vt=function(e,t,r){for(var n,o=r.split(","),i=0,s=o.length;i<s;i++)(n=o[i])&&e.registerName(t,n)},Ut=function(e,t){for(var r,n=(null!==(r=t.textContent)&&void 0!==r?r:"").split(Ze),o=[],i=0,s=n.length;i<s;i++){var a=n[i].trim();if(a){var c=a.match(Gt);if(c){var l=0|parseInt(c[1],10),u=c[2];0!==l&&(Wt(u,l),Vt(e,u,c[3]),e.getTag().insertRules(l,o)),o.length=0}else o.push(a)}}},Yt=function(e){for(var t=document.querySelectorAll(Ht),r=0,n=t.length;r<n;r++){var o=t[r];o&&o.getAttribute(qe)!==Xe&&(Ut(e,o),o.parentNode&&o.parentNode.removeChild(o))}};var qt=function(e){var t,r,n=document.head,o=e||n,i=document.createElement("style"),s=(t=o,(r=Array.from(t.querySelectorAll("style[".concat(qe,"]"))))[r.length-1]),a=void 0!==s?s.nextSibling:null;i.setAttribute(qe,Xe),i.setAttribute(Je,Ke);var c="undefined"!=typeof __webpack_nonce__?__webpack_nonce__:null;return c&&i.setAttribute("nonce",c),o.insertBefore(i,a),i},Xt=function(){function e(e){this.element=qt(e),this.element.appendChild(document.createTextNode("")),this.sheet=function(e){if(e.sheet)return e.sheet;for(var t=document.styleSheets,r=0,n=t.length;r<n;r++){var o=t[r];if(o.ownerNode===e)return o}throw Nt(17)}(this.element),this.length=0}return e.prototype.insertRule=function(e,t){try{return this.sheet.insertRule(t,e),this.length++,!0}catch(r){return!1}},e.prototype.deleteRule=function(e){this.sheet.deleteRule(e),this.length--},e.prototype.getRule=function(e){var t=this.sheet.cssRules[e];return t&&t.cssText?t.cssText:""},e}(),Jt=function(){function e(e){this.element=qt(e),this.nodes=this.element.childNodes,this.length=0}return e.prototype.insertRule=function(e,t){if(e<=this.length&&e>=0){var r=document.createTextNode(t);return this.element.insertBefore(r,this.nodes[e]||null),this.length++,!0}return!1},e.prototype.deleteRule=function(e){this.element.removeChild(this.nodes[e]),this.length--},e.prototype.getRule=function(e){return e<this.length?this.nodes[e].textContent:""},e}(),Kt=function(){function e(e){this.rules=[],this.length=0}return e.prototype.insertRule=function(e,t){return e<=this.length&&(this.rules.splice(e,0,t),this.length++,!0)},e.prototype.deleteRule=function(e){this.rules.splice(e,1),this.length--},e.prototype.getRule=function(e){return e<this.length?this.rules[e]:""},e}(),Zt=Qe,Qt={isServer:!Qe,useCSSOMInjection:!et},er=function(){function e(e,t,r){void 0===e&&(e=rt),void 0===t&&(t={});var n=this;this.options=X(X({},Qt),e),this.gs=t,this.names=new Map(r),this.server=!!e.isServer,!this.server&&Qe&&Zt&&(Zt=!1,Yt(this)),Dt(this,(function(){return function(e){for(var t=e.getTag(),r=t.length,n="",o=function(r){var o,i=(o=r,Tt.get(o));if(void 0===i)return"continue";var s=e.names.get(i),a=t.getGroup(r);if(void 0===s||!s.size||0===a.length)return"continue";var c="".concat(qe,".g").concat(r,'[id="').concat(i,'"]'),l="";void 0!==s&&s.forEach((function(e){e.length>0&&(l+="".concat(e,","))})),n+="".concat(a).concat(c,'{content:"').concat(l,'"}').concat(Ze)},i=0;i<r;i++)o(i);return n}(n)}))}return e.registerId=function(e){return Bt(e)},e.prototype.rehydrate=function(){!this.server&&Qe&&Yt(this)},e.prototype.reconstructWithOptions=function(t,r){return void 0===r&&(r=!0),new e(X(X({},this.options),t),this.gs,r&&this.names||void 0)},e.prototype.allocateGSInstance=function(e){return this.gs[e]=(this.gs[e]||0)+1},e.prototype.getTag=function(){return this.tag||(this.tag=(e=this.options,t=e.useCSSOMInjection,r=e.target,n=e.isServer?new Kt(r):t?new Xt(r):new Jt(r),new Lt(n)));var e,t,r,n},e.prototype.hasNameForId=function(e,t){return this.names.has(e)&&this.names.get(e).has(t)},e.prototype.registerName=function(e,t){if(Bt(e),this.names.has(e))this.names.get(e).add(t);else{var r=new Set;r.add(t),this.names.set(e,r)}},e.prototype.insertRules=function(e,t,r){this.registerName(e,t),this.getTag().insertRules(Bt(e),r)},e.prototype.clearNames=function(e){this.names.has(e)&&this.names.get(e).clear()},e.prototype.clearRules=function(e){this.getTag().clearGroup(Bt(e)),this.clearNames(e)},e.prototype.clearTag=function(){this.tag=void 0},e}(),tr=/&/g,rr=/^\s*\/\/.*$/gm;function nr(e,t){return e.map((function(e){return"rule"===e.type&&(e.value="".concat(t," ").concat(e.value),e.value=e.value.replaceAll(",",",".concat(t," ")),e.props=e.props.map((function(e){return"".concat(t," ").concat(e)}))),Array.isArray(e.children)&&"@keyframes"!==e.type&&(e.children=nr(e.children,t)),e}))}var or=new er,ir=function(){var e,t,r,n=rt,o=n.options,i=void 0===o?rt:o,s=n.plugins,a=void 0===s?tt:s,c=function(r,n,o){return o.startsWith(t)&&o.endsWith(t)&&o.replaceAll(t,"").length>0?".".concat(e):r},l=a.slice();l.push((function(e){e.type===te&&e.value.includes("&")&&(e.props[0]=e.props[0].replace(tr,t).replace(r,c))})),i.prefix&&l.push(Ve),l.push(Ge);var u=function(n,o,s,a){void 0===o&&(o=""),void 0===s&&(s=""),void 0===a&&(a="&"),e=a,t=o,r=new RegExp("\\".concat(t,"\\b"),"g");var c=n.replace(rr,""),u=Le(s||o?"".concat(s," ").concat(o," { ").concat(c," }"):c);i.namespace&&(u=nr(u,i.namespace));var d,p,f,h=[];return He(u,(d=l.concat((f=function(e){return h.push(e)},function(e){e.root||(e=e.return)&&f(e)})),p=he(d),function(e,t,r,n){for(var o="",i=0;i<p;i++)o+=d[i](e,t,r,n)||"";return o})),h};return u.hash=a.length?a.reduce((function(e,t){return t.name||Nt(15),dt(e,t.name)}),5381).toString():"",u}(),sr=r.createContext({shouldForwardProp:void 0,styleSheet:or,stylis:ir});function ar(){return e.useContext(sr)}sr.Consumer,r.createContext(void 0);var cr=function(){function e(e,t){var r=this;this.inject=function(e,t){void 0===t&&(t=ir);var n=r.name+t.hash;e.hasNameForId(r.id,n)||e.insertRules(r.id,n,t(r.rules,n,"@keyframes"))},this.name=e,this.id="sc-keyframes-".concat(e),this.rules=t,Dt(this,(function(){throw Nt(12,String(r.name))}))}return e.prototype.getName=function(e){return void 0===e&&(e=ir),this.name+e.hash},e}(),lr=function(e){return e>="A"&&e<="Z"};function ur(e){for(var t="",r=0;r<e.length;r++){var n=e[r];if(1===r&&"-"===n&&"-"===e[0])return e;lr(n)?t+="-"+n.toLowerCase():t+=n}return t.startsWith("ms-")?"-"+t:t}var dr=function(e){return null==e||!1===e||""===e},pr=function(e){var t,r,n=[];for(var o in e){var i=e[o];e.hasOwnProperty(o)&&!dr(i)&&(Array.isArray(i)&&i.isCss||It(i)?n.push("".concat(ur(o),":"),i,";"):$t(i)?n.push.apply(n,J(J(["".concat(o," {")],pr(i),!1),["}"],!1)):n.push("".concat(ur(o),": ").concat((t=o,null==(r=i)||"boolean"==typeof r||""===r?"":"number"!=typeof r||0===r||t in Ue||t.startsWith("--")?String(r).trim():"".concat(r,"px")),";")))}return n};function fr(e,t,r,n){return dr(e)?[]:Pt(e)?[".".concat(e.styledComponentId)]:It(e)?!It(o=e)||o.prototype&&o.prototype.isReactComponent||!t?[e]:fr(e(t),t,r,n):e instanceof cr?r?(e.inject(r,n),[e.getName(n)]):[e]:$t(e)?pr(e):Array.isArray(e)?Array.prototype.concat.apply(tt,e.map((function(e){return fr(e,t,r,n)}))):[e.toString()];var o}var hr=pt(Ke),mr=function(){function e(e,t,r){this.rules=e,this.staticRulesId="",this.isStatic=(void 0===r||r.isStatic)&&function(e){for(var t=0;t<e.length;t+=1){var r=e[t];if(It(r)&&!Pt(r))return!1}return!0}(e),this.componentId=t,this.baseHash=dt(hr,t),this.baseStyle=r,er.registerId(t)}return e.prototype.generateAndInjectStyles=function(e,t,r){var n=this.baseStyle?this.baseStyle.generateAndInjectStyles(e,t,r):"";if(this.isStatic&&!r.hash)if(this.staticRulesId&&t.hasNameForId(this.componentId,this.staticRulesId))n=Rt(n,this.staticRulesId);else{var o=zt(fr(this.rules,e,t,r)),i=lt(dt(this.baseHash,o)>>>0);if(!t.hasNameForId(this.componentId,i)){var s=r(o,".".concat(i),void 0,this.componentId);t.insertRules(this.componentId,i,s)}n=Rt(n,i),this.staticRulesId=i}else{for(var a=dt(this.baseHash,r.hash),c="",l=0;l<this.rules.length;l++){var u=this.rules[l];if("string"==typeof u)c+=u;else if(u){var d=zt(fr(u,e,t,r));a=dt(a,d+l),c+=d}}if(c){var p=lt(a>>>0);t.hasNameForId(this.componentId,p)||t.insertRules(this.componentId,p,r(c,".".concat(p),void 0,this.componentId)),n=Rt(n,p)}}return n},e}(),gr=r.createContext(void 0);gr.Consumer;var vr={};function yr(t,n,o){var i,s=Pt(t),a=t,c=!ft(t),l=n.attrs,u=void 0===l?tt:l,d=n.componentId,p=void 0===d?function(e,t){var r="string"!=typeof e?"sc":st(e);vr[r]=(vr[r]||0)+1;var n="".concat(r,"-").concat(function(e){return lt(pt(e)>>>0)}(Ke+r+vr[r]));return t?"".concat(t,"-").concat(n):n}(n.displayName,n.parentComponentId):d,f=n.displayName,h=void 0===f?ft(i=t)?"styled.".concat(i):"Styled(".concat(function(e){return e.displayName||e.name||"Component"}(i),")"):f,m=n.displayName&&n.componentId?"".concat(st(n.displayName),"-").concat(n.componentId):n.componentId||p,g=s&&a.attrs?a.attrs.concat(u).filter(Boolean):u,v=n.shouldForwardProp;if(s&&a.shouldForwardProp){var y=a.shouldForwardProp;if(n.shouldForwardProp){var x=n.shouldForwardProp;v=function(e,t){return y(e,t)&&x(e,t)}}else v=y}var b=new mr(o,m,s?a.componentStyle:void 0);function w(t,n){return function(t,n,o){var i=t.attrs,s=t.componentStyle,a=t.defaultProps,c=t.foldedComponentIds,l=t.styledComponentId,u=t.target,d=r.useContext(gr),p=ar(),f=t.shouldForwardProp||p.shouldForwardProp,h=function(e,t,r){return void 0===r&&(r=rt),e.theme!==r.theme&&e.theme||t||r.theme}(n,d,a)||rt,m=function(e,t,r){for(var n,o=X(X({},t),{className:void 0,theme:r}),i=0;i<e.length;i+=1){var s=It(n=e[i])?n(o):n;for(var a in s)o[a]="className"===a?Rt(o[a],s[a]):"style"===a?X(X({},o[a]),s[a]):s[a]}return t.className&&(o.className=Rt(o.className,t.className)),o}(i,n,h),g=m.as||u,v={};for(var y in m)void 0===m[y]||"$"===y[0]||"as"===y||"theme"===y&&m.theme===h||("forwardedAs"===y?v.as=m.forwardedAs:f&&!f(y,g)||(v[y]=m[y]));var x,b,w,j=(x=s,b=m,w=ar(),x.generateAndInjectStyles(b,w.styleSheet,w.stylis)),k=Rt(c,l);return j&&(k+=" "+j),m.className&&(k+=" "+m.className),v[ft(g)&&!nt.has(g)?"class":"className"]=k,o&&(v.ref=o),e.createElement(g,v)}(j,t,n)}w.displayName=h;var j=r.forwardRef(w);return j.attrs=g,j.componentStyle=b,j.displayName=h,j.shouldForwardProp=v,j.foldedComponentIds=s?Rt(a.foldedComponentIds,a.styledComponentId):"",j.styledComponentId=m,j.target=s?a.target:t,Object.defineProperty(j,"defaultProps",{get:function(){return this._foldedDefaultProps},set:function(e){this._foldedDefaultProps=s?function(e){for(var t=[],r=1;r<arguments.length;r++)t[r-1]=arguments[r];for(var n=0,o=t;n<o.length;n++)Mt(e,o[n],!0);return e}({},a.defaultProps,e):e}}),Dt(j,(function(){return".".concat(j.styledComponentId)})),c&&Et(j,t,{attrs:!0,componentStyle:!0,displayName:!0,foldedComponentIds:!0,shouldForwardProp:!0,styledComponentId:!0,target:!0}),j}function xr(e,t){for(var r=[e[0]],n=0,o=t.length;n<o;n+=1)r.push(t[n],e[n+1]);return r}var br=function(e){return Object.assign(e,{isCss:!0})};function wr(e){for(var t=[],r=1;r<arguments.length;r++)t[r-1]=arguments[r];if(It(e)||$t(e))return br(fr(xr(tt,J([e],t,!0))));var n=e;return 0===t.length&&1===n.length&&"string"==typeof n[0]?fr(n):br(fr(xr(n,t)))}function jr(e,t,r){if(void 0===r&&(r=rt),!t)throw Nt(1,t);var n=function(n){for(var o=[],i=1;i<arguments.length;i++)o[i-1]=arguments[i];return e(t,r,wr.apply(void 0,J([n],o,!1)))};return n.attrs=function(n){return jr(e,t,X(X({},r),{attrs:Array.prototype.concat(r.attrs,n).filter(Boolean)}))},n.withConfig=function(n){return jr(e,t,X(X({},r),n))},n}var kr=function(e){return jr(yr,e)},Sr=kr;nt.forEach((function(e){Sr[e]=kr(e)}));const Cr=Sr.div`
	min-height: 100vh;
	width: 100vw;
	// background: #eaeaea;
	position: relative;
	overflow: hidden;
`,_r=Sr.div`
	position: absolute;
	top: 30%;
	left: 4rem;
	background: rgba(20, 30, 40, 0.95);
	color: #fff;
	border-radius: 10px;
	box-shadow: 0 4px 24px rgba(0,0,0,0.2);
	padding: 1.6rem 1.6rem;
	min-width: 340px;
	z-index: 10;
  overflow: hidden;

  border-radius: var(--radius-sm, 0.4rem);
  border: 1px solid var(-           -white-opacity-100, rgba(255, 255, 255, 0.10));
  background-blend-mode: normal, normal, difference, normal;
`,Ar=Sr.div`
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
`,Er=Sr.span`
  display: flex;
  width: 60px;
  height: 60px;
  // padding: 1.4rem;
  justify-content: center;
  align-items: center;
	border-radius: var(--radius-md, 0.8rem);
  border: 1px solid var(--main-500, #0DC8E7);
  background: var(--main-900, #184D61);
`,Ir=Sr.div`
  color: var(--white-opacity-500, rgba(255, 255, 255, 0.50));

  /* detail */
  font-family: Inter;
  font-size: 1.2rem;
  font-style: normal;
  font-weight: 500;
`,Pr=Sr.ul`
	list-style: none;
	padding: 0;
	margin: 0;
`,Rr=Sr.hr`
  border: none;
  border-top: 1.5px solid rgba(255,255,255,0.10);
  margin: 1.1rem 0 1.3rem 0;
  width: 121%;
  transform: translateX(-8.5%);
`,zr=Sr.li`
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
`,$r=Sr.span`
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
`,Mr=Sr.div`
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
`,Dr=Sr.div`
	display: flex;
	flex-direction: row;
	gap: 2.2rem;
	margin-top: 0.5rem;
`,Nr=Sr.div`
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
`;function Lr(){const[t,r]=e.useState("movement"),[n,o]=e.useState({walk:!1,jump:!1,crouch:!1,inventory:!1,enter:!1,belt:!1,ignition:!1,drive:!1}),[i,s]=e.useState({w:!1,a:!1,s:!1,d:!1,space:!1,ctrl:!1,f:!1,c:!1,z:!1,i:!1}),[a,c]=e.useState(!0),[l,u]=e.useState(!1),[p,f]=e.useState(40),{t:h}=d(),m=[{label:h("walk_step"),key:"walk"},{label:h("jump_step"),key:"jump"},{label:h("crouch_step"),key:"crouch"}],g=[{label:h("car_step_enter"),key:"enter"},{label:h("car_step_belt"),key:"belt"},{label:h("car_step_drive"),key:"drive"}],v=[{label:h("inventory_step_open"),key:"open"},{label:h("inventory_step_trash"),key:"trash"},{label:h("inventory_step_eat"),key:"eat"},{label:h("inventory_step_pickup"),key:"pickup"}],y=[{label:h("action_walk"),keys:["W","A","S","D"],key:"walk"},{label:h("action_jump"),keys:["SPACE"],key:"jump"},{label:h("action_crouch"),keys:["CTRL"],key:"crouch"}],x=[{label:h("car_step_enter"),keys:["F"],key:"enter"},{label:h("car_step_belt"),keys:["G"],key:"belt"},{label:h("car_step_drive"),keys:["W","A","S","D"],key:"drive"}],b=[{label:h("inventory_step_open"),keys:["I"],key:"open"},{label:h("inventory_step_trash"),keys:[],key:"trash"},{label:h("inventory_step_eat"),keys:[],key:"eat"},{label:h("inventory_step_pickup"),keys:[],key:"pickup"}],w={movement:{walk:!1,jump:!1,crouch:!1},car:{enter:!1,belt:!1,ignition:!1,drive:!1},inventory:{open:!1,trash:!1,eat:!1,pickup:!1}};e.useEffect((()=>{o("movement"===t||"car"===t||"inventory"===t?w[t]:{})}),[t]);const j="car"===t?g:"inventory"===t?v:m,S="car"===t?x:"inventory"===t?b:y;function C(e){return"SPACE"===e?"space":"CTRL"===e?"ctrl":e.toLowerCase()}const _=Sr.div`
	  position: fixed;
	  top: 0; left: 0; right: 0; bottom: 0;
	  background: rgba(0,0,0,0.45);
	  z-index: 1000;
	  display: flex;
	  align-items: center;
	  justify-content: center;
	`,A=Sr.div`
	  background: #18232e;
	  color: #fff;
	  border-radius: 12px;
	  box-shadow: 0 4px 24px rgba(0,0,0,0.2);
	  padding: 2rem 2.5rem 1.5rem 2.5rem;
	  text-align: flex-start;
    min-width: 32.2rem;

    border-radius: var(--radius-sm, 0.4rem);
        border: 1px solid var(--white-opacity-100, rgba(255, 255, 255, 0.10));
	`,E=Sr.div`
    color: var(--white-opacity-900, #FFF);

    /* h4 */
    font-family: Inter;
    font-size: 2rem;
    font-style: normal;
    font-weight: 600;
    line-height: 2.4rem;
	`,I=Sr.div`
    color: var(--white-opacity-500, rgba(255, 255, 255, 0.50));

    /* small */
    font-family: Inter;
    font-size: 1.4rem;
    font-style: normal;
    font-weight: 500;
    margin-bottom: 1.6rem;
	`,P=Sr.div`
	  display: flex;
	  gap: 1rem;
	  justify-content: center;
	`,z=Sr.button`
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
	`,M=Sr(z)`
	  background: #222d38;
	  color: #b0b8c1;
	  width: 100%;
	  &:hover {
	    background: #2c3a4a;
	    color: #fff;
	  }
	`;H("setTutorialVisible",(e=>{c(e),e||u(!1)})),H("updateTutorialProgress",(e=>{o((t=>({...t,...e})))})),H("updateTutorialType",(e=>{r(e)})),e.useEffect((()=>{const e=e=>{const r=e.key.toLowerCase();"car"===t?("f"===r&&(s((e=>({...e,f:!0}))),o((e=>({...e,enter:!0})))),"b"===r&&(s((e=>({...e,b:!0}))),o((e=>({...e,belt:!0})))),"l"===r&&(s((e=>({...e,l:!0}))),o((e=>({...e,ignition:!0})))),["w","a","s","d"].includes(r)&&(s((e=>({...e,[r]:!0}))),o((e=>({...e,drive:!0}))))):"inventory"===t?("i"===r&&o((e=>({...e,open:!0}))),"del"===r&&o((e=>({...e,trash:!0}))),"e"===r&&o((e=>({...e,eat:!0}))),"p"===r&&o((e=>({...e,pickup:!0})))):(["w","a","s","d","f","c","z","i"].includes(r)&&(s((e=>({...e,[r]:!0}))),["w","a","s","d"].includes(r)&&o((e=>({...e,walk:!0}))))," "!==r&&"spacebar"!==r||(s((e=>({...e,space:!0}))),o((e=>({...e,jump:!0})))),"control"!==r&&"ctrl"!==r||(s((e=>({...e,ctrl:!0}))),o((e=>({...e,crouch:!0})))),"i"===r&&o((e=>({...e,inventory:!0}))))},r=e=>{const t=e.key.toLowerCase();s((e=>({...e,[t]:!1})))};return window.addEventListener("keydown",e),window.addEventListener("keyup",r),()=>{window.removeEventListener("keydown",e),window.removeEventListener("keyup",r)}}),[t]);const D=j.find((e=>!n[e.key])),N=S.find((e=>e.key===(null==D?void 0:D.key))),L=N?N.keys:[];return e.useEffect((()=>{window.focus()}),[]),e.useEffect((()=>{if(!a)return;if(p<=0)return c(!1),void u(!1);const e=setTimeout((()=>f((e=>e-1))),1e3);return()=>clearTimeout(e)}),[p,a]),a?k.jsx(_,{children:k.jsxs(A,{children:[k.jsx(E,{children:h("tutorial_prompt_title")}),k.jsx(I,{children:h("tutorial_prompt_desc")}),k.jsxs(P,{children:[k.jsx(z,{onClick:()=>{c(!1),u(!0),R()||$({path:"tutorialAccepted",payload:{accepted:!0}})},children:h("btn_yes")}),k.jsx(M,{onClick:()=>{c(!1),u(!1),R()||$({path:"tutorialAccepted",payload:{accepted:!1}})},children:h("btn_skip")})]}),k.jsxs("div",{style:{textAlign:"center",marginTop:"1.2rem",color:"var(--white-opacity-500, rgba(255, 255, 255, 0.50))",fontSize:"1.2rem",fontWeight:500},children:[h("skipping_tutorial_in")," ",k.jsxs("span",{style:{color:"var(--main-200, #A7F1FA)",fontWeight:500},children:[p," ",h("seconds")]})]})]})}):l?k.jsxs(Cr,{style:{display:"flex",alignItems:"flex-start",height:"100vh"},children:[k.jsxs(_r,{children:[k.jsxs("div",{style:{display:"flex",alignItems:"center",justifyContent:"flex-start",gap:"12px",marginBottom:"1.2rem"},children:[k.jsx(Er,{children:"movement"===t?k.jsx(Y,{style:{width:"24px",height:"28px"}}):"inventory"===t?k.jsx(V,{style:{width:"24px",height:"28px"}}):k.jsx(U,{style:{width:"24px",height:"28px"}})}),k.jsxs("div",{style:{display:"flex",flexDirection:"column",justifyContent:"flex-start"},children:[k.jsx(Ar,{children:h("movement"===t?"tutorial_movement_title":"inventory"===t?"tutorial_inventory_title":"tutorial_car_title")}),k.jsx(Ir,{children:h("movement"===t?"tutorial_movement_desc":"inventory"===t?"tutorial_inventory_desc":"tutorial_car_desc")})]})]}),k.jsx(Rr,{}),k.jsx(Pr,{children:j.map((e=>k.jsxs(zr,{done:n[e.key],children:[k.jsx($r,{checked:n[e.key],children:n[e.key]&&k.jsx(q,{})}),e.label]},e.key)))}),k.jsx(Rr,{style:{margin:"1.6rem 0"}}),k.jsxs("div",{style:{display:"flex",alignItems:"center",justifyContent:"center",gap:"12px",width:"100%"},children:[k.jsx(Er,{style:{width:"3.2rem",height:"3.2rem",color:"var(--main-200)",fontSize:"1.4rem",fontWeight:600,lineHeight:"2rem"},children:"H"}),k.jsx("div",{style:{display:"flex",flexDirection:"column",justifyContent:"flex-start"},children:k.jsx(Ar,{style:{color:"#FFF",fontSize:"1.4rem",fontWeight:500,lineHeight:"2rem"},children:h("tutorial_cancel")})})]})]}),L.length>0&&k.jsxs(Mr,{children:[k.jsx(Dr,{style:{justifyContent:"center",marginBottom:"0.2rem",gap:"0"},children:1===L.length?k.jsx(Nr,{style:{fontSize:"2rem",minWidth:70,height:70},active:!!i[C(L[0])],onMouseDown:()=>s((e=>({...e,[C(L[0])]:!0}))),onMouseUp:()=>s((e=>({...e,[C(L[0])]:!1}))),onMouseLeave:()=>s((e=>({...e,[C(L[0])]:!1}))),children:L[0]}):null}),4===L.length&&"WASD"===L.join("")?k.jsxs("div",{style:{display:"flex",flexDirection:"column",alignItems:"center",gap:"0.5rem"},children:[k.jsx(Dr,{style:{justifyContent:"center",gap:"2.2rem"},children:k.jsx(Nr,{active:!!i.w,onMouseDown:()=>s((e=>({...e,w:!0}))),onMouseUp:()=>s((e=>({...e,w:!1}))),onMouseLeave:()=>s((e=>({...e,w:!1}))),children:"W"},"W")}),k.jsx(Dr,{style:{justifyContent:"center",gap:"2.2rem"},children:["A","S","D"].map((e=>k.jsx(Nr,{active:!!i[e.toLowerCase()],onMouseDown:()=>s((t=>({...t,[e.toLowerCase()]:!0}))),onMouseUp:()=>s((t=>({...t,[e.toLowerCase()]:!1}))),onMouseLeave:()=>s((t=>({...t,[e.toLowerCase()]:!1}))),children:e},e)))})]}):null,L.length>1&&!(4===L.length&&"WASD"===L.join(""))&&k.jsx(Dr,{children:L.map((e=>k.jsx(Nr,{active:!!i[C(e)],onMouseDown:()=>s((t=>({...t,[C(e)]:!0}))),onMouseUp:()=>s((t=>({...t,[C(e)]:!1}))),onMouseLeave:()=>s((t=>({...t,[C(e)]:!1}))),children:e},e)))})]}),R()&&k.jsx("div",{style:{position:"fixed",top:10,right:10,zIndex:9999},children:k.jsxs("button",{onClick:()=>r("movement"===t?"car":"car"===t?"inventory":"movement"),style:{padding:8,background:"#0DC8E7",color:"#222",border:0,borderRadius:6,fontWeight:600},children:["Alternar para tutorial: ","movement"===t?"Carro":"car"===t?"Inventário":"Movimento"]})})]}):null}const Fr=l((e=>({cityId:"",setCityId:t=>e({cityId:t}),userInfos:{name:"Boynull",passport:1234567890,role:"Gangster",avatar:"https://cdn.discordapp.com/attachments/1165533333333333333/1165533333333333333/image.png"},setUserInfos:t=>e({userInfos:t}),userPermissions:{},setUserPermissions:t=>e({userPermissions:t})}))),Tr=e.createContext({url:"",isReady:!1});function Or({children:t}){const[r,n]=e.useState({url:""}),[o,i]=e.useState(!!R());return e.useEffect((()=>{(async()=>{try{const e=(await u("getServerHost",{})).replace(/^(https?:\/\/)/,"");n({url:e}),i(!0)}catch(e){n({url:"api.santagroup.com.br"}),i(!0)}})()}),[]),k.jsx(Tr.Provider,{value:{...r,isReady:o},children:t})}const Br=e=>k.jsxs("svg",{xmlns:"http://www.w3.org/2000/svg",width:"30",height:"38",fill:"none",viewBox:"0 0 30 38",children:[k.jsx("path",{fill:"var(--main-200)",d:"M11.675 11.962c1.798 0 3.257-1.48 3.257-3.306S13.473 5.35 11.675 5.35 8.418 6.83 8.418 8.656s1.458 3.306 3.257 3.306"}),k.jsx("path",{fill:"var(--main-200)",d:"M29.68 29.462c-1.687-3.004-4.216-5.054-7.322-6.345-.192-3.91-2.064-7.59-5.07-10.074-1.525-1.262-3.63-1.502-5.117.028a3 3 0 0 0-.256.3c-3.065-1.773-6.44-3.1-9.556-4.174-2.364-.814-3.37 2.972-1.027 3.78 3.528 1.214 7.406 2.788 10.634 5.07q.11.114.232.22c1.85 1.528 2.999 3.345 2.935 5.805-.01.401.035.765.121 1.099a29 29 0 0 1-.862 3.755c-1.141-1.197-2.204-2.463-3.088-3.886-1.655-2.664-5.832-.207-4.167 2.471 1.775 2.857 4.089 5.224 6.522 7.498 1.023.956 3.155 1.03 3.79-.496.954-2.293 1.715-4.603 2.228-6.985.156-.039.308-.091.458-.147q.243.17.545.288a9.15 9.15 0 0 1 3.86 2.83c-1.111 1.177-2.33 2.226-3.793 2.981-2.773 1.434-.33 5.66 2.435 4.229 2.415-1.248 4.393-3.19 6.118-5.281.714-.86.953-1.944.38-2.966M9.644 4.848c.455-.17.944-.512 1.457-.512 1.153 0 2.198.472 2.96 1.235a138 138 0 0 1-1.43-4.21C11.867-1.031 8.14-.006 8.91 2.405c.235.736.487 1.712.735 2.444"})]}),Wr=e=>k.jsxs("svg",{xmlns:"http://www.w3.org/2000/svg",width:"24",height:"38",fill:"none",viewBox:"0 0 24 38",children:[k.jsx("path",{fill:"var(--main-200)",d:"M15.528 10.488a5.244 5.244 0 1 0 0-10.488 5.244 5.244 0 0 0 0 10.488M18.732 33.742l.58.581a1.86 1.86 0 0 0 2.637.006c.56-.557.69-1.38.393-2.064a3.5 3.5 0 0 1-.664.344zM12.19 14.658a1.864 1.864 0 1 0-3.668.674l1.732 9.43q.006.02.01.04l5.423.595-1.87-1.878z"}),k.jsx("path",{fill:"var(--main-200)",d:"m8.196 30.975-3.62 1.392a2.914 2.914 0 0 0 2.091 5.438l14.819-5.696a2.914 2.914 0 0 0-.727-5.615L9.447 25.25l-.294-.032q.193-.606.42-1.205l-1.578-8.586a2.403 2.403 0 0 1 2.366-2.835c1.156 0 2.147.828 2.356 1.968l.394 2.144c1.259-2.032 1.192-4.893-.557-5.922-1.768-1.04-4.84-.821-6.933 2.12C2.768 16.961 1.573 19.8.684 24.935c-.365 3.806 1.993 4.904 4.049 5.483.504.142.944.253 1.331.291q.104.026.213.045c.06.01.12.023.181.03z"})]}),Hr=e=>k.jsx("svg",{xmlns:"http://www.w3.org/2000/svg",width:"28",height:"38",fill:"none",viewBox:"0 0 28 38",children:k.jsx("path",{fill:"var(--main-200)",d:"M27.526 8.746a.77.77 0 0 0-.835.168c-3.075 3.06-6.065 1.572-9.522-.145-3.098-1.534-6.555-3.243-9.99-.928V5.848a2.68 2.68 0 0 0 1.916-2.56A2.686 2.686 0 0 0 6.412.603 2.686 2.686 0 0 0 3.73 3.287c0 1.211.812 2.223 1.916 2.56v26.129C3.138 32.267.938 33.946.05 36.36a.75.75 0 0 0 .092.706c.138.206.375.33.628.33h11.294a.77.77 0 0 0 .72-1.035 6.83 6.83 0 0 0-5.604-4.386v-8.94c2.998-2.767 5.926-1.326 9.307.353 2.001.99 4.163 2.063 6.371 2.063 1.626 0 3.282-.583 4.915-2.209a.77.77 0 0 0 .23-.544V9.46a.77.77 0 0 0-.476-.713M7.18 20.023V10.84c.95.713 1.54 1.54 1.794 2.507.513 2.008-.468 4.385-1.794 6.677"})}),Gr=e=>k.jsx("svg",{xmlns:"http://www.w3.org/2000/svg",width:"26",height:"34",fill:"none",viewBox:"0 0 26 34",children:k.jsx("path",{fill:"var(--main-200)",d:"m15.335 28.34 1.378-2.239c.31-.495.765-.883 1.322-1.12a12.925 12.925 0 0 0 7.903-11.919c0-3.555-1.485-6.991-4.078-9.427A12.83 12.83 0 0 0 12.173.153C5.575.563.254 6.071.068 12.686c-.152 5.377 2.948 10.203 7.903 12.296a2.82 2.82 0 0 1 1.317 1.12l1.378 2.238C7.403 28.587 4 29.409 4 31.063c0 1.935 4.663 2.812 9 2.812s9-.877 9-2.812c0-1.654-3.403-2.476-6.665-2.723M5.125 13.063c0-4.343 3.533-7.876 7.875-7.876s7.875 3.533 7.875 7.876c0 4.342-3.532 7.874-7.875 7.874-4.342 0-7.875-3.532-7.875-7.875M13 32.75c-5.197 0-7.875-1.181-7.875-1.687 0-.383 1.856-1.407 6.21-1.637l1.187 1.929c.101.169.281.27.478.27a.55.55 0 0 0 .478-.27l1.187-1.93c4.354.231 6.21 1.255 6.21 1.637 0 .507-2.677 1.688-7.875 1.688"})}),Vr=e=>k.jsx("svg",{xmlns:"http://www.w3.org/2000/svg",width:"28",height:"32",fill:"none",viewBox:"0 0 28 32",children:k.jsx("path",{fill:"var(--main-200)",d:"M13.919 0c.861 0 1.688.337 2.297.937s.951 1.414.951 2.263c0 1.776-1.445 3.2-3.248 3.2a3.27 3.27 0 0 1-2.297-.937A3.18 3.18 0 0 1 10.67 3.2c0-.849.342-1.663.95-2.263.61-.6 1.436-.937 2.298-.937m.633 20.464a56 56 0 0 1 6.903.4c.097-4.352-.293-8.192-1.04-9.664a4.4 4.4 0 0 0-.812-1.12L6.497 21.152c2.208-.352 4.986-.688 8.055-.688M6.545 24c.211 2.784.634 5.6 1.316 8h3.362c-.471-1.408-.812-3.056-1.072-4.8 0 0 3.768-.704 7.536 0-.26 1.744-.601 3.392-1.072 4.8h3.362c.714-2.48 1.137-5.424 1.348-8.336a58 58 0 0 0-6.773-.4c-3.134 0-5.863.336-8.007.736M13.92 8s-4.873 0-6.497 3.2c-.552 1.088-.91 3.44-1.023 6.336l10.638-8.992C15.43 8 13.92 8 13.92 8m10.67-2.128-1.851-2.128-5.7 4.816c.892.304 1.834.784 2.565 1.52zM28 22.128c-.146-.048-2.485-.8-6.545-1.264a56 56 0 0 1-.13 2.8c3.654.448 5.75 1.136 5.782 1.136zM6.4 17.536 0 22.944l1.445 2.368c.033-.016 1.917-.736 5.1-1.312a55 55 0 0 1-.146-6.464"})}),Ur=e=>k.jsx("svg",{xmlns:"http://www.w3.org/2000/svg",width:"28",height:"29",fill:"none",viewBox:"0 0 28 29",children:k.jsx("path",{fill:"var(--main-200)",d:"M19.907 0c1.126 0 2.22.38 3.109 1.079a5.1 5.1 0 0 1 1.793 2.778l.598 2.414h1.42c.282 0 .555.103.767.29s.35.445.389.726l.01.16c0 .284-.101.559-.287.773a1.16 1.16 0 0 1-.72.392l-.159.011h-.833l.323 1.295c.514.315.939.758 1.234 1.286a3.55 3.55 0 0 1 .449 1.73v13.322c0 .728-.287 1.426-.797 1.94a2.7 2.7 0 0 1-1.925.804H22.94a2.7 2.7 0 0 1-1.924-.804 2.76 2.76 0 0 1-.797-1.94l-.002-1.955H7.782v1.955c0 .728-.286 1.426-.797 1.94A2.7 2.7 0 0 1 5.061 29H2.72a2.7 2.7 0 0 1-1.924-.804A2.76 2.76 0 0 1 0 26.256V12.935c0-1.278.673-2.398 1.683-3.015l.322-1.297h-.839c-.281 0-.554-.103-.766-.29a1.18 1.18 0 0 1-.39-.726L0 7.447c0-.284.102-.559.287-.773.186-.214.442-.353.72-.392l.16-.01h1.42l.6-2.412A5.1 5.1 0 0 1 4.98 1.08 5.03 5.03 0 0 1 8.09 0zM5.447 24.301H2.332l.002 1.955a.39.39 0 0 0 .389.392H5.06a.387.387 0 0 0 .388-.392zm20.219 0h-3.119l.002 1.955a.39.39 0 0 0 .389.392h2.339a.39.39 0 0 0 .389-.392zm-8.946-7.055h-5.446l-.159.011c-.28.039-.535.178-.72.392a1.18 1.18 0 0 0 0 1.546c.185.214.44.353.72.392l.159.01h5.446l.157-.01c.293-.04.56-.192.746-.423a1.183 1.183 0 0 0-.108-1.6 1.16 1.16 0 0 0-.795-.318m5.053-3.136a1.55 1.55 0 0 0-1.1.46 1.574 1.574 0 0 0 0 2.217 1.55 1.55 0 0 0 2.2 0 1.574 1.574 0 0 0 0-2.217 1.55 1.55 0 0 0-1.1-.46m-15.552 0c-.413 0-.808.166-1.1.46a1.574 1.574 0 0 0 0 2.217 1.55 1.55 0 0 0 2.2 0 1.574 1.574 0 0 0 0-2.217 1.55 1.55 0 0 0-1.1-.46M19.907 2.352H8.089c-.607 0-1.197.204-1.676.581a2.75 2.75 0 0 0-.965 1.498L4.216 9.407h19.568l-1.238-4.98a2.75 2.75 0 0 0-.966-1.495 2.7 2.7 0 0 0-1.675-.58"})}),Yr=Sr.div`
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
`,qr=Sr.div`
  color: var(--white, #FFF);

  /* h4 */
  font-family: Inter;
  font-size: 2rem;
  font-style: normal;
  font-weight: 600;
  line-height: 2.8rem; /* 140% */
  letter-spacing: -0.01rem;
`,Xr=Sr.div`
  color: var(--white-opacity-500, rgba(255, 255, 255, 0.50));

  /* detail */
  font-family: Inter;
  font-size: 1.2rem;
  font-style: normal;
  font-weight: 500;
  line-height: 2rem; /* 166.667% */
`,Jr=Sr.div`
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
`;Sr.img`
  width: 24px; // Adjust size as needed
  height: 24px; // Adjust size as needed
`;const Kr=({title:t,description:r,position:n,style:o,image:i})=>{const[s,a]=e.useState(!0);return k.jsxs(Yr,{style:{...o,top:n.top,left:n.left,zIndex:n.zIndex,transform:n.transform},className:s?"visible":"",children:[k.jsx(Jr,{children:"jump"===i&&k.jsx(Br,{})||"crounch"===i&&k.jsx(Wr,{})||"flag"===i&&k.jsx(Hr,{})||"point"===i&&k.jsx(Gr,{})||"belt"===i&&k.jsx(Vr,{})||"car"===i&&k.jsx(Ur,{})}),k.jsxs("div",{style:{display:"flex",flexDirection:"column",alignItems:"flex-start",justifyContent:"flex-start"},children:[k.jsx(qr,{children:t}),k.jsx(Xr,{children:r})]})]})},Zr=e.createContext(void 0),Qr=({children:t})=>{const[r,n]=e.useState({title:"Tutorial",description:"Tutorial",image:"jump"});return k.jsx(Zr.Provider,{value:{tooltipData:r,setTooltipData:n},children:t})},en=()=>{const t=e.useContext(Zr);if(!t)throw new Error("useTooltip must be used within a TooltipProvider");return t},tn=()=>{const{tooltipData:e}=en();return k.jsx("div",{children:e&&k.jsx(Kr,{title:e.title,description:e.description,image:e.image,position:{top:"50%",left:"50%",zIndex:1e3,transform:"translate(-50%, -60%)"},style:{position:"fixed",top:"50%",left:"50%",transform:"translate(-50%, -60%)",zIndex:1e3}})})};function rn(){const{setCityId:t}=Fr(),{isReady:r}=e.useContext(Tr),[a,c]=e.useState("cidadenobre"),[l,d]=e.useState(!0),{setVisible:p}=M((e=>e)),f=n(),{setTooltipData:h}=en();return e.useEffect((()=>{u("getCityName",{},"Maresia").then((e=>{c(e)})),u("Init")}),[]),H("getCityName",(e=>{c(e)})),e.useEffect((()=>{(async()=>{try{const e=document.createElement("link");e.rel="stylesheet",e.href=`https://santaimagens.roleplayrp.com/img/themes/${a}.css`,document.head.appendChild(e)}catch(e){}})()}),[a]),W("Escape",(async()=>{u("closeNui"),p(!1)})),H("setVisible",(async e=>{p(e),f("/start")})),H("showTooltip",(e=>{p(!0),h(e),f("/tutorial")})),k.jsx(G,{children:k.jsxs(o,{children:[k.jsx(i,{path:"/",element:k.jsx(s,{to:"/tutorial"})}),k.jsx(i,{path:"/start",element:k.jsx(Lr,{})}),k.jsx(i,{path:"/tutorial",element:k.jsx(tn,{})})]})})}if(R()){const e=document.getElementById("root");e.style.backgroundImage="url('https://files.catbox.moe/5te7js.png')",e.style.backgroundSize="cover",e.style.backgroundRepeat="no-repeat",e.style.backgroundPosition="center",e.style.height="100vh"}S.createRoot(document.getElementById("root")).render(k.jsx(r.StrictMode,{children:k.jsx(a,{children:k.jsx(p,{customTheme:{borders:{main:{100:"1px solid rgba(255, 255, 255, 0.1)",200:"1px solid rgba(255, 255, 255, 0.2)",300:"1px solid rgba(255, 255, 255, 0.3)"}},colors:{main:{50:"#ff8f0026",100:"#ff8f0040",200:"#ff8f0080",300:"#ff8f00cc",400:"#ff8f00ff",500:"#ff8f00ff",600:"#ff8f00ff",700:"#ff8f00ff",800:"#ff8f00ff",900:"#ff8f00e6"}},logo:"https://example.com/logo.png",smallLogo:"https://example.com/small-logo.png",isFromHookCache:!1,images:{background:"https://example.com/background.jpg"},tag:"default"},children:k.jsx(f,{children:k.jsx(Or,{children:k.jsx(Qr,{children:k.jsx(rn,{})})})})})})}));
