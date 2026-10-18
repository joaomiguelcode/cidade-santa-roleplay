import{r as e,R as t,H as r,a as n,b as i,c as o}from"./react-vendor-xQMM9M15.js";import{u as a,c as s,f as c,C as l,a as d}from"./utils-vendor-DH--Z_rb.js";!function(){const e=document.createElement("link").relList;if(!(e&&e.supports&&e.supports("modulepreload"))){for(const e of document.querySelectorAll('link[rel="modulepreload"]'))t(e);new MutationObserver(e=>{for(const r of e)if("childList"===r.type)for(const e of r.addedNodes)"LINK"===e.tagName&&"modulepreload"===e.rel&&t(e)}).observe(document,{childList:!0,subtree:!0})}function t(e){if(e.ep)return;e.ep=!0;const t=function(e){const t={};return e.integrity&&(t.integrity=e.integrity),e.referrerPolicy&&(t.referrerPolicy=e.referrerPolicy),"use-credentials"===e.crossOrigin?t.credentials="include":"anonymous"===e.crossOrigin?t.credentials="omit":t.credentials="same-origin",t}(e);fetch(e.href,t)}}();var u={exports:{}},f={},h=e,m=Symbol.for("react.element"),p=Symbol.for("react.fragment"),g=Object.prototype.hasOwnProperty,y=h.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED.ReactCurrentOwner,v={key:!0,ref:!0,__self:!0,__source:!0};function x(e,t,r){var n,i={},o=null,a=null;for(n in void 0!==r&&(o=""+r),void 0!==t.key&&(o=""+t.key),void 0!==t.ref&&(a=t.ref),t)g.call(t,n)&&!v.hasOwnProperty(n)&&(i[n]=t[n]);if(e&&e.defaultProps)for(n in t=e.defaultProps)void 0===i[n]&&(i[n]=t[n]);return{$$typeof:m,type:e,key:o,ref:a,props:i,_owner:y.current}}f.Fragment=p,f.jsx=x,f.jsxs=x,u.exports=f;var w=u.exports;const b=()=>w.jsxs("svg",{className:"-translate-y-1/2 -translate-x-1/2 fixed top-1/2 left-1/2 z-40 animate-spin text-gray-300",viewBox:"0 0 64 64",fill:"none",xmlns:"http://www.w3.org/2000/svg",width:"1.5rem",height:"1.5rem",children:[w.jsx("path",{d:"M32 3C35.8083 3 39.5794 3.75011 43.0978 5.20749C46.6163 6.66488 49.8132 8.80101 52.5061 11.4939C55.199 14.1868 57.3351 17.3837 58.7925 20.9022C60.2499 24.4206 61 28.1917 61 32C61 35.8083 60.2499 39.5794 58.7925 43.0978C57.3351 46.6163 55.199 49.8132 52.5061 52.5061C49.8132 55.199 46.6163 57.3351 43.0978 58.7925C39.5794 60.2499 35.8083 61 32 61C28.1917 61 24.4206 60.2499 20.9022 58.7925C17.3837 57.3351 14.1868 55.199 11.4939 52.5061C8.801 49.8132 6.66487 46.6163 5.20749 43.0978C3.7501 39.5794 3 35.8083 3 32C3 28.1917 3.75011 24.4206 5.2075 20.9022C6.66489 17.3837 8.80101 14.1868 11.4939 11.4939C14.1868 8.80099 17.3838 6.66487 20.9022 5.20749C24.4206 3.7501 28.1917 3 32 3L32 3Z",stroke:"currentColor",strokeWidth:"5",strokeLinecap:"round",strokeLinejoin:"round"}),w.jsx("path",{d:"M32 3C36.5778 3 41.0906 4.08374 45.1692 6.16256C49.2477 8.24138 52.7762 11.2562 55.466 14.9605C58.1558 18.6647 59.9304 22.9531 60.6448 27.4748C61.3591 31.9965 60.9928 36.6232 59.5759 40.9762",stroke:"currentColor",strokeWidth:"5",strokeLinecap:"round",strokeLinejoin:"round",className:"text-[#22F690]"})]});var S=function(){return S=Object.assign||function(e){for(var t,r=1,n=arguments.length;r<n;r++)for(var i in t=arguments[r])Object.prototype.hasOwnProperty.call(t,i)&&(e[i]=t[i]);return e},S.apply(this,arguments)};function j(e,t,r){if(r||2===arguments.length)for(var n,i=0,o=t.length;i<o;i++)!n&&i in t||(n||(n=Array.prototype.slice.call(t,0,i)),n[i]=t[i]);return e.concat(n||Array.prototype.slice.call(t))}"function"==typeof SuppressedError&&SuppressedError;var k="-ms-",C="-moz-",I="-webkit-",E="comm",_="rule",A="decl",N="@keyframes",$=Math.abs,P=String.fromCharCode,R=Object.assign;function z(e){return e.trim()}function O(e,t){return(e=t.exec(e))?e[0]:e}function D(e,t,r){return e.replace(t,r)}function M(e,t,r){return e.indexOf(t,r)}function T(e,t){return 0|e.charCodeAt(t)}function L(e,t,r){return e.slice(t,r)}function F(e){return e.length}function B(e){return e.length}function G(e,t){return t.push(e),e}function H(e,t){return e.filter(function(e){return!O(e,t)})}var W=1,Y=1,U=0,q=0,Q=0,J="";function X(e,t,r,n,i,o,a,s){return{value:e,root:t,parent:r,type:n,props:i,children:o,line:W,column:Y,length:a,return:"",siblings:s}}function V(e,t){return R(X("",null,null,"",null,null,0,e.siblings),e,{length:-e.length},t)}function Z(e){for(;e.root;)e=V(e.root,{children:[e]});G(e,e.siblings)}function K(){return Q=q>0?T(J,--q):0,Y--,10===Q&&(Y=1,W--),Q}function ee(){return Q=q<U?T(J,q++):0,Y++,10===Q&&(Y=1,W++),Q}function te(){return T(J,q)}function re(){return q}function ne(e,t){return L(J,e,t)}function ie(e){switch(e){case 0:case 9:case 10:case 13:case 32:return 5;case 33:case 43:case 44:case 47:case 62:case 64:case 126:case 59:case 123:case 125:return 4;case 58:return 3;case 34:case 39:case 40:case 91:return 2;case 41:case 93:return 1}return 0}function oe(e){return z(ne(q-1,ce(91===e?e+2:40===e?e+1:e)))}function ae(e){for(;(Q=te())&&Q<33;)ee();return ie(e)>2||ie(Q)>3?"":" "}function se(e,t){for(;--t&&ee()&&!(Q<48||Q>102||Q>57&&Q<65||Q>70&&Q<97););return ne(e,re()+(t<6&&32==te()&&32==ee()))}function ce(e){for(;ee();)switch(Q){case e:return q;case 34:case 39:34!==e&&39!==e&&ce(Q);break;case 40:41===e&&ce(e);break;case 92:ee()}return q}function le(e,t){for(;ee()&&e+Q!==57&&(e+Q!==84||47!==te()););return"/*"+ne(t,q-1)+"*"+P(47===e?e:ee())}function de(e){for(;!ie(te());)ee();return ne(e,q)}function ue(e){return function(e){return J="",e}(fe("",null,null,null,[""],e=function(e){return W=Y=1,U=F(J=e),q=0,[]}(e),0,[0],e))}function fe(e,t,r,n,i,o,a,s,c){for(var l=0,d=0,u=a,f=0,h=0,m=0,p=1,g=1,y=1,v=0,x="",w=i,b=o,S=n,j=x;g;)switch(m=v,v=ee()){case 40:if(108!=m&&58==T(j,u-1)){-1!=M(j+=D(oe(v),"&","&\f"),"&\f",$(l?s[l-1]:0))&&(y=-1);break}case 34:case 39:case 91:j+=oe(v);break;case 9:case 10:case 13:case 32:j+=ae(m);break;case 92:j+=se(re()-1,7);continue;case 47:switch(te()){case 42:case 47:G(me(le(ee(),re()),t,r,c),c);break;default:j+="/"}break;case 123*p:s[l++]=F(j)*y;case 125*p:case 59:case 0:switch(v){case 0:case 125:g=0;case 59+d:-1==y&&(j=D(j,/\f/g,"")),h>0&&F(j)-u&&G(h>32?pe(j+";",n,r,u-1,c):pe(D(j," ","")+";",n,r,u-2,c),c);break;case 59:j+=";";default:if(G(S=he(j,t,r,l,d,i,s,x,w=[],b=[],u,o),o),123===v)if(0===d)fe(j,t,S,S,w,o,u,s,b);else switch(99===f&&110===T(j,3)?100:f){case 100:case 108:case 109:case 115:fe(e,S,S,n&&G(he(e,S,S,0,0,i,s,x,i,w=[],u,b),b),i,b,u,s,n?w:b);break;default:fe(j,S,S,S,[""],b,0,s,b)}}l=d=h=0,p=y=1,x=j="",u=a;break;case 58:u=1+F(j),h=m;default:if(p<1)if(123==v)--p;else if(125==v&&0==p++&&125==K())continue;switch(j+=P(v),v*p){case 38:y=d>0?1:(j+="\f",-1);break;case 44:s[l++]=(F(j)-1)*y,y=1;break;case 64:45===te()&&(j+=oe(ee())),f=te(),d=u=F(x=j+=de(re())),v++;break;case 45:45===m&&2==F(j)&&(p=0)}}return o}function he(e,t,r,n,i,o,a,s,c,l,d,u){for(var f=i-1,h=0===i?o:[""],m=B(h),p=0,g=0,y=0;p<n;++p)for(var v=0,x=L(e,f+1,f=$(g=a[p])),w=e;v<m;++v)(w=z(g>0?h[v]+" "+x:D(x,/&\f/g,h[v])))&&(c[y++]=w);return X(e,t,r,0===i?_:s,c,l,d,u)}function me(e,t,r,n){return X(e,t,r,E,P(Q),L(e,2,-2),0,n)}function pe(e,t,r,n,i){return X(e,t,r,A,L(e,0,n),L(e,n+1,-1),n,i)}function ge(e,t,r){switch(function(e,t){return 45^T(e,0)?(((t<<2^T(e,0))<<2^T(e,1))<<2^T(e,2))<<2^T(e,3):0}(e,t)){case 5103:return I+"print-"+e+e;case 5737:case 4201:case 3177:case 3433:case 1641:case 4457:case 2921:case 5572:case 6356:case 5844:case 3191:case 6645:case 3005:case 6391:case 5879:case 5623:case 6135:case 4599:case 4855:case 4215:case 6389:case 5109:case 5365:case 5621:case 3829:return I+e+e;case 4789:return C+e+e;case 5349:case 4246:case 4810:case 6968:case 2756:return I+e+C+e+k+e+e;case 5936:switch(T(e,t+11)){case 114:return I+e+k+D(e,/[svh]\w+-[tblr]{2}/,"tb")+e;case 108:return I+e+k+D(e,/[svh]\w+-[tblr]{2}/,"tb-rl")+e;case 45:return I+e+k+D(e,/[svh]\w+-[tblr]{2}/,"lr")+e}case 6828:case 4268:case 2903:return I+e+k+e+e;case 6165:return I+e+k+"flex-"+e+e;case 5187:return I+e+D(e,/(\w+).+(:[^]+)/,I+"box-$1$2"+k+"flex-$1$2")+e;case 5443:return I+e+k+"flex-item-"+D(e,/flex-|-self/g,"")+(O(e,/flex-|baseline/)?"":k+"grid-row-"+D(e,/flex-|-self/g,""))+e;case 4675:return I+e+k+"flex-line-pack"+D(e,/align-content|flex-|-self/g,"")+e;case 5548:return I+e+k+D(e,"shrink","negative")+e;case 5292:return I+e+k+D(e,"basis","preferred-size")+e;case 6060:return I+"box-"+D(e,"-grow","")+I+e+k+D(e,"grow","positive")+e;case 4554:return I+D(e,/([^-])(transform)/g,"$1"+I+"$2")+e;case 6187:return D(D(D(e,/(zoom-|grab)/,I+"$1"),/(image-set)/,I+"$1"),e,"")+e;case 5495:case 3959:return D(e,/(image-set\([^]*)/,I+"$1$`$1");case 4968:return D(D(e,/(.+:)(flex-)?(.*)/,I+"box-pack:$3"+k+"flex-pack:$3"),/s.+-b[^;]+/,"justify")+I+e+e;case 4200:if(!O(e,/flex-|baseline/))return k+"grid-column-align"+L(e,t)+e;break;case 2592:case 3360:return k+D(e,"template-","")+e;case 4384:case 3616:return r&&r.some(function(e,r){return t=r,O(e.props,/grid-\w+-end/)})?~M(e+(r=r[t].value),"span",0)?e:k+D(e,"-start","")+e+k+"grid-row-span:"+(~M(r,"span",0)?O(r,/\d+/):+O(r,/\d+/)-+O(e,/\d+/))+";":k+D(e,"-start","")+e;case 4896:case 4128:return r&&r.some(function(e){return O(e.props,/grid-\w+-start/)})?e:k+D(D(e,"-end","-span"),"span ","")+e;case 4095:case 3583:case 4068:case 2532:return D(e,/(.+)-inline(.+)/,I+"$1$2")+e;case 8116:case 7059:case 5753:case 5535:case 5445:case 5701:case 4933:case 4677:case 5533:case 5789:case 5021:case 4765:if(F(e)-1-t>6)switch(T(e,t+1)){case 109:if(45!==T(e,t+4))break;case 102:return D(e,/(.+:)(.+)-([^]+)/,"$1"+I+"$2-$3$1"+C+(108==T(e,t+3)?"$3":"$2-$3"))+e;case 115:return~M(e,"stretch",0)?ge(D(e,"stretch","fill-available"),t,r)+e:e}break;case 5152:case 5920:return D(e,/(.+?):(\d+)(\s*\/\s*(span)?\s*(\d+))?(.*)/,function(t,r,n,i,o,a,s){return k+r+":"+n+s+(i?k+r+"-span:"+(o?a:+a-+n)+s:"")+e});case 4949:if(121===T(e,t+6))return D(e,":",":"+I)+e;break;case 6444:switch(T(e,45===T(e,14)?18:11)){case 120:return D(e,/(.+:)([^;\s!]+)(;|(\s+)?!.+)?/,"$1"+I+(45===T(e,14)?"inline-":"")+"box$3$1"+I+"$2$3$1"+k+"$2box$3")+e;case 100:return D(e,":",":"+k)+e}break;case 5719:case 2647:case 2135:case 3927:case 2391:return D(e,"scroll-","scroll-snap-")+e}return e}function ye(e,t){for(var r="",n=0;n<e.length;n++)r+=t(e[n],n,e,t)||"";return r}function ve(e,t,r,n){switch(e.type){case"@layer":if(e.children.length)break;case"@import":case A:return e.return=e.return||e.value;case E:return"";case N:return e.return=e.value+"{"+ye(e.children,n)+"}";case _:if(!F(e.value=e.props.join(",")))return""}return F(r=ye(e.children,n))?e.return=e.value+"{"+r+"}":""}function xe(e,t,r,n){if(e.length>-1&&!e.return)switch(e.type){case A:return void(e.return=ge(e.value,e.length,r));case N:return ye([V(e,{value:D(e.value,"@","@"+I)})],n);case _:if(e.length)return function(e,t){return e.map(t).join("")}(r=e.props,function(t){switch(O(t,n=/(::plac\w+|:read-\w+)/)){case":read-only":case":read-write":Z(V(e,{props:[D(t,/:(read-\w+)/,":-moz-$1")]})),Z(V(e,{props:[t]})),R(e,{props:H(r,n)});break;case"::placeholder":Z(V(e,{props:[D(t,/:(plac\w+)/,":"+I+"input-$1")]})),Z(V(e,{props:[D(t,/:(plac\w+)/,":-moz-$1")]})),Z(V(e,{props:[D(t,/:(plac\w+)/,k+"input-$1")]})),Z(V(e,{props:[t]})),R(e,{props:H(r,n)})}return""})}}var we={animationIterationCount:1,aspectRatio:1,borderImageOutset:1,borderImageSlice:1,borderImageWidth:1,boxFlex:1,boxFlexGroup:1,boxOrdinalGroup:1,columnCount:1,columns:1,flex:1,flexGrow:1,flexPositive:1,flexShrink:1,flexNegative:1,flexOrder:1,gridRow:1,gridRowEnd:1,gridRowSpan:1,gridRowStart:1,gridColumn:1,gridColumnEnd:1,gridColumnSpan:1,gridColumnStart:1,msGridRow:1,msGridRowSpan:1,msGridColumn:1,msGridColumnSpan:1,fontWeight:1,lineHeight:1,opacity:1,order:1,orphans:1,tabSize:1,widows:1,zIndex:1,zoom:1,WebkitLineClamp:1,fillOpacity:1,floodOpacity:1,stopOpacity:1,strokeDasharray:1,strokeDashoffset:1,strokeMiterlimit:1,strokeOpacity:1,strokeWidth:1},be={},Se="undefined"!=typeof process&&void 0!==be&&(be.REACT_APP_SC_ATTR||be.SC_ATTR)||"data-styled",je="active",ke="data-styled-version",Ce="6.1.19",Ie="/*!sc*/\n",Ee="undefined"!=typeof window&&"undefined"!=typeof document,_e=Boolean("boolean"==typeof SC_DISABLE_SPEEDY?SC_DISABLE_SPEEDY:"undefined"!=typeof process&&void 0!==be&&void 0!==be.REACT_APP_SC_DISABLE_SPEEDY&&""!==be.REACT_APP_SC_DISABLE_SPEEDY?"false"!==be.REACT_APP_SC_DISABLE_SPEEDY&&be.REACT_APP_SC_DISABLE_SPEEDY:"undefined"!=typeof process&&void 0!==be&&void 0!==be.SC_DISABLE_SPEEDY&&""!==be.SC_DISABLE_SPEEDY&&("false"!==be.SC_DISABLE_SPEEDY&&be.SC_DISABLE_SPEEDY)),Ae=Object.freeze([]),Ne=Object.freeze({});var $e=new Set(["a","abbr","address","area","article","aside","audio","b","base","bdi","bdo","big","blockquote","body","br","button","canvas","caption","cite","code","col","colgroup","data","datalist","dd","del","details","dfn","dialog","div","dl","dt","em","embed","fieldset","figcaption","figure","footer","form","h1","h2","h3","h4","h5","h6","header","hgroup","hr","html","i","iframe","img","input","ins","kbd","keygen","label","legend","li","link","main","map","mark","menu","menuitem","meta","meter","nav","noscript","object","ol","optgroup","option","output","p","param","picture","pre","progress","q","rp","rt","ruby","s","samp","script","section","select","small","source","span","strong","style","sub","summary","sup","table","tbody","td","textarea","tfoot","th","thead","time","tr","track","u","ul","use","var","video","wbr","circle","clipPath","defs","ellipse","foreignObject","g","image","line","linearGradient","marker","mask","path","pattern","polygon","polyline","radialGradient","rect","stop","svg","text","tspan"]),Pe=/[!"#$%&'()*+,./:;<=>?@[\\\]^`{|}~-]+/g,Re=/(^-|-$)/g;function ze(e){return e.replace(Pe,"-").replace(Re,"")}var Oe=/(a)(d)/gi,De=function(e){return String.fromCharCode(e+(e>25?39:97))};function Me(e){var t,r="";for(t=Math.abs(e);t>52;t=t/52|0)r=De(t%52)+r;return(De(t%52)+r).replace(Oe,"$1-$2")}var Te,Le=function(e,t){for(var r=t.length;r;)e=33*e^t.charCodeAt(--r);return e},Fe=function(e){return Le(5381,e)};function Be(e){return"string"==typeof e&&!0}var Ge="function"==typeof Symbol&&Symbol.for,He=Ge?Symbol.for("react.memo"):60115,We=Ge?Symbol.for("react.forward_ref"):60112,Ye={childContextTypes:!0,contextType:!0,contextTypes:!0,defaultProps:!0,displayName:!0,getDefaultProps:!0,getDerivedStateFromError:!0,getDerivedStateFromProps:!0,mixins:!0,propTypes:!0,type:!0},Ue={name:!0,length:!0,prototype:!0,caller:!0,callee:!0,arguments:!0,arity:!0},qe={$$typeof:!0,compare:!0,defaultProps:!0,displayName:!0,propTypes:!0,type:!0},Qe=((Te={})[We]={$$typeof:!0,render:!0,defaultProps:!0,displayName:!0,propTypes:!0},Te[He]=qe,Te);function Je(e){return("type"in(t=e)&&t.type.$$typeof)===He?qe:"$$typeof"in e?Qe[e.$$typeof]:Ye;var t}var Xe=Object.defineProperty,Ve=Object.getOwnPropertyNames,Ze=Object.getOwnPropertySymbols,Ke=Object.getOwnPropertyDescriptor,et=Object.getPrototypeOf,tt=Object.prototype;function rt(e,t,r){if("string"!=typeof t){if(tt){var n=et(t);n&&n!==tt&&rt(e,n,r)}var i=Ve(t);Ze&&(i=i.concat(Ze(t)));for(var o=Je(e),a=Je(t),s=0;s<i.length;++s){var c=i[s];if(!(c in Ue||r&&r[c]||a&&c in a||o&&c in o)){var l=Ke(t,c);try{Xe(e,c,l)}catch(d){}}}}return e}function nt(e){return"function"==typeof e}function it(e){return"object"==typeof e&&"styledComponentId"in e}function ot(e,t){return e&&t?"".concat(e," ").concat(t):e||t||""}function at(e,t){if(0===e.length)return"";for(var r=e[0],n=1;n<e.length;n++)r+=e[n];return r}function st(e){return null!==e&&"object"==typeof e&&e.constructor.name===Object.name&&!("props"in e&&e.$$typeof)}function ct(e,t,r){if(void 0===r&&(r=!1),!r&&!st(e)&&!Array.isArray(e))return t;if(Array.isArray(t))for(var n=0;n<t.length;n++)e[n]=ct(e[n],t[n]);else if(st(t))for(var n in t)e[n]=ct(e[n],t[n]);return e}function lt(e,t){Object.defineProperty(e,"toString",{value:t})}function dt(e){for(var t=[],r=1;r<arguments.length;r++)t[r-1]=arguments[r];return new Error("An error occurred. See https://github.com/styled-components/styled-components/blob/main/packages/styled-components/src/utils/errors.md#".concat(e," for more information.").concat(t.length>0?" Args: ".concat(t.join(", ")):""))}var ut=function(){function e(e){this.groupSizes=new Uint32Array(512),this.length=512,this.tag=e}return e.prototype.indexOfGroup=function(e){for(var t=0,r=0;r<e;r++)t+=this.groupSizes[r];return t},e.prototype.insertRules=function(e,t){if(e>=this.groupSizes.length){for(var r=this.groupSizes,n=r.length,i=n;e>=i;)if((i<<=1)<0)throw dt(16,"".concat(e));this.groupSizes=new Uint32Array(i),this.groupSizes.set(r),this.length=i;for(var o=n;o<i;o++)this.groupSizes[o]=0}for(var a=this.indexOfGroup(e+1),s=(o=0,t.length);o<s;o++)this.tag.insertRule(a,t[o])&&(this.groupSizes[e]++,a++)},e.prototype.clearGroup=function(e){if(e<this.length){var t=this.groupSizes[e],r=this.indexOfGroup(e),n=r+t;this.groupSizes[e]=0;for(var i=r;i<n;i++)this.tag.deleteRule(r)}},e.prototype.getGroup=function(e){var t="";if(e>=this.length||0===this.groupSizes[e])return t;for(var r=this.groupSizes[e],n=this.indexOfGroup(e),i=n+r,o=n;o<i;o++)t+="".concat(this.tag.getRule(o)).concat(Ie);return t},e}(),ft=new Map,ht=new Map,mt=1,pt=function(e){if(ft.has(e))return ft.get(e);for(;ht.has(mt);)mt++;var t=mt++;return ft.set(e,t),ht.set(t,e),t},gt=function(e,t){mt=t+1,ft.set(e,t),ht.set(t,e)},yt="style[".concat(Se,"][").concat(ke,'="').concat(Ce,'"]'),vt=new RegExp("^".concat(Se,'\\.g(\\d+)\\[id="([\\w\\d-]+)"\\].*?"([^"]*)')),xt=function(e,t,r){for(var n,i=r.split(","),o=0,a=i.length;o<a;o++)(n=i[o])&&e.registerName(t,n)},wt=function(e,t){for(var r,n=(null!==(r=t.textContent)&&void 0!==r?r:"").split(Ie),i=[],o=0,a=n.length;o<a;o++){var s=n[o].trim();if(s){var c=s.match(vt);if(c){var l=0|parseInt(c[1],10),d=c[2];0!==l&&(gt(d,l),xt(e,d,c[3]),e.getTag().insertRules(l,i)),i.length=0}else i.push(s)}}},bt=function(e){for(var t=document.querySelectorAll(yt),r=0,n=t.length;r<n;r++){var i=t[r];i&&i.getAttribute(Se)!==je&&(wt(e,i),i.parentNode&&i.parentNode.removeChild(i))}};var St=function(e){var t,r,n=document.head,i=e||n,o=document.createElement("style"),a=(t=i,(r=Array.from(t.querySelectorAll("style[".concat(Se,"]"))))[r.length-1]),s=void 0!==a?a.nextSibling:null;o.setAttribute(Se,je),o.setAttribute(ke,Ce);var c="undefined"!=typeof __webpack_nonce__?__webpack_nonce__:null;return c&&o.setAttribute("nonce",c),i.insertBefore(o,s),o},jt=function(){function e(e){this.element=St(e),this.element.appendChild(document.createTextNode("")),this.sheet=function(e){if(e.sheet)return e.sheet;for(var t=document.styleSheets,r=0,n=t.length;r<n;r++){var i=t[r];if(i.ownerNode===e)return i}throw dt(17)}(this.element),this.length=0}return e.prototype.insertRule=function(e,t){try{return this.sheet.insertRule(t,e),this.length++,!0}catch(r){return!1}},e.prototype.deleteRule=function(e){this.sheet.deleteRule(e),this.length--},e.prototype.getRule=function(e){var t=this.sheet.cssRules[e];return t&&t.cssText?t.cssText:""},e}(),kt=function(){function e(e){this.element=St(e),this.nodes=this.element.childNodes,this.length=0}return e.prototype.insertRule=function(e,t){if(e<=this.length&&e>=0){var r=document.createTextNode(t);return this.element.insertBefore(r,this.nodes[e]||null),this.length++,!0}return!1},e.prototype.deleteRule=function(e){this.element.removeChild(this.nodes[e]),this.length--},e.prototype.getRule=function(e){return e<this.length?this.nodes[e].textContent:""},e}(),Ct=function(){function e(e){this.rules=[],this.length=0}return e.prototype.insertRule=function(e,t){return e<=this.length&&(this.rules.splice(e,0,t),this.length++,!0)},e.prototype.deleteRule=function(e){this.rules.splice(e,1),this.length--},e.prototype.getRule=function(e){return e<this.length?this.rules[e]:""},e}(),It=Ee,Et={isServer:!Ee,useCSSOMInjection:!_e},_t=function(){function e(e,t,r){void 0===e&&(e=Ne),void 0===t&&(t={});var n=this;this.options=S(S({},Et),e),this.gs=t,this.names=new Map(r),this.server=!!e.isServer,!this.server&&Ee&&It&&(It=!1,bt(this)),lt(this,function(){return function(e){for(var t=e.getTag(),r=t.length,n="",i=function(r){var i,o=(i=r,ht.get(i));if(void 0===o)return"continue";var a=e.names.get(o),s=t.getGroup(r);if(void 0===a||!a.size||0===s.length)return"continue";var c="".concat(Se,".g").concat(r,'[id="').concat(o,'"]'),l="";void 0!==a&&a.forEach(function(e){e.length>0&&(l+="".concat(e,","))}),n+="".concat(s).concat(c,'{content:"').concat(l,'"}').concat(Ie)},o=0;o<r;o++)i(o);return n}(n)})}return e.registerId=function(e){return pt(e)},e.prototype.rehydrate=function(){!this.server&&Ee&&bt(this)},e.prototype.reconstructWithOptions=function(t,r){return void 0===r&&(r=!0),new e(S(S({},this.options),t),this.gs,r&&this.names||void 0)},e.prototype.allocateGSInstance=function(e){return this.gs[e]=(this.gs[e]||0)+1},e.prototype.getTag=function(){return this.tag||(this.tag=(e=this.options,t=e.useCSSOMInjection,r=e.target,n=e.isServer?new Ct(r):t?new jt(r):new kt(r),new ut(n)));var e,t,r,n},e.prototype.hasNameForId=function(e,t){return this.names.has(e)&&this.names.get(e).has(t)},e.prototype.registerName=function(e,t){if(pt(e),this.names.has(e))this.names.get(e).add(t);else{var r=new Set;r.add(t),this.names.set(e,r)}},e.prototype.insertRules=function(e,t,r){this.registerName(e,t),this.getTag().insertRules(pt(e),r)},e.prototype.clearNames=function(e){this.names.has(e)&&this.names.get(e).clear()},e.prototype.clearRules=function(e){this.getTag().clearGroup(pt(e)),this.clearNames(e)},e.prototype.clearTag=function(){this.tag=void 0},e}(),At=/&/g,Nt=/^\s*\/\/.*$/gm;function $t(e,t){return e.map(function(e){return"rule"===e.type&&(e.value="".concat(t," ").concat(e.value),e.value=e.value.replaceAll(",",",".concat(t," ")),e.props=e.props.map(function(e){return"".concat(t," ").concat(e)})),Array.isArray(e.children)&&"@keyframes"!==e.type&&(e.children=$t(e.children,t)),e})}var Pt=new _t,Rt=function(){var e,t,r,n=Ne,i=n.options,o=void 0===i?Ne:i,a=n.plugins,s=void 0===a?Ae:a,c=function(r,n,i){return i.startsWith(t)&&i.endsWith(t)&&i.replaceAll(t,"").length>0?".".concat(e):r},l=s.slice();l.push(function(e){e.type===_&&e.value.includes("&")&&(e.props[0]=e.props[0].replace(At,t).replace(r,c))}),o.prefix&&l.push(xe),l.push(ve);var d=function(n,i,a,s){void 0===i&&(i=""),void 0===a&&(a=""),void 0===s&&(s="&"),e=s,t=i,r=new RegExp("\\".concat(t,"\\b"),"g");var c=n.replace(Nt,""),d=ue(a||i?"".concat(a," ").concat(i," { ").concat(c," }"):c);o.namespace&&(d=$t(d,o.namespace));var u,f,h,m=[];return ye(d,(u=l.concat((h=function(e){return m.push(e)},function(e){e.root||(e=e.return)&&h(e)})),f=B(u),function(e,t,r,n){for(var i="",o=0;o<f;o++)i+=u[o](e,t,r,n)||"";return i})),m};return d.hash=s.length?s.reduce(function(e,t){return t.name||dt(15),Le(e,t.name)},5381).toString():"",d}(),zt=t.createContext({shouldForwardProp:void 0,styleSheet:Pt,stylis:Rt});function Ot(){return e.useContext(zt)}zt.Consumer,t.createContext(void 0);var Dt=function(){function e(e,t){var r=this;this.inject=function(e,t){void 0===t&&(t=Rt);var n=r.name+t.hash;e.hasNameForId(r.id,n)||e.insertRules(r.id,n,t(r.rules,n,"@keyframes"))},this.name=e,this.id="sc-keyframes-".concat(e),this.rules=t,lt(this,function(){throw dt(12,String(r.name))})}return e.prototype.getName=function(e){return void 0===e&&(e=Rt),this.name+e.hash},e}(),Mt=function(e){return e>="A"&&e<="Z"};function Tt(e){for(var t="",r=0;r<e.length;r++){var n=e[r];if(1===r&&"-"===n&&"-"===e[0])return e;Mt(n)?t+="-"+n.toLowerCase():t+=n}return t.startsWith("ms-")?"-"+t:t}var Lt=function(e){return null==e||!1===e||""===e},Ft=function(e){var t,r,n=[];for(var i in e){var o=e[i];e.hasOwnProperty(i)&&!Lt(o)&&(Array.isArray(o)&&o.isCss||nt(o)?n.push("".concat(Tt(i),":"),o,";"):st(o)?n.push.apply(n,j(j(["".concat(i," {")],Ft(o),!1),["}"],!1)):n.push("".concat(Tt(i),": ").concat((t=i,null==(r=o)||"boolean"==typeof r||""===r?"":"number"!=typeof r||0===r||t in we||t.startsWith("--")?String(r).trim():"".concat(r,"px")),";")))}return n};function Bt(e,t,r,n){return Lt(e)?[]:it(e)?[".".concat(e.styledComponentId)]:nt(e)?!nt(i=e)||i.prototype&&i.prototype.isReactComponent||!t?[e]:Bt(e(t),t,r,n):e instanceof Dt?r?(e.inject(r,n),[e.getName(n)]):[e]:st(e)?Ft(e):Array.isArray(e)?Array.prototype.concat.apply(Ae,e.map(function(e){return Bt(e,t,r,n)})):[e.toString()];var i}var Gt=Fe(Ce),Ht=function(){function e(e,t,r){this.rules=e,this.staticRulesId="",this.isStatic=(void 0===r||r.isStatic)&&function(e){for(var t=0;t<e.length;t+=1){var r=e[t];if(nt(r)&&!it(r))return!1}return!0}(e),this.componentId=t,this.baseHash=Le(Gt,t),this.baseStyle=r,_t.registerId(t)}return e.prototype.generateAndInjectStyles=function(e,t,r){var n=this.baseStyle?this.baseStyle.generateAndInjectStyles(e,t,r):"";if(this.isStatic&&!r.hash)if(this.staticRulesId&&t.hasNameForId(this.componentId,this.staticRulesId))n=ot(n,this.staticRulesId);else{var i=at(Bt(this.rules,e,t,r)),o=Me(Le(this.baseHash,i)>>>0);if(!t.hasNameForId(this.componentId,o)){var a=r(i,".".concat(o),void 0,this.componentId);t.insertRules(this.componentId,o,a)}n=ot(n,o),this.staticRulesId=o}else{for(var s=Le(this.baseHash,r.hash),c="",l=0;l<this.rules.length;l++){var d=this.rules[l];if("string"==typeof d)c+=d;else if(d){var u=at(Bt(d,e,t,r));s=Le(s,u+l),c+=u}}if(c){var f=Me(s>>>0);t.hasNameForId(this.componentId,f)||t.insertRules(this.componentId,f,r(c,".".concat(f),void 0,this.componentId)),n=ot(n,f)}}return n},e}(),Wt=t.createContext(void 0);Wt.Consumer;var Yt={};function Ut(r,n,i){var o,a=it(r),s=r,c=!Be(r),l=n.attrs,d=void 0===l?Ae:l,u=n.componentId,f=void 0===u?function(e,t){var r="string"!=typeof e?"sc":ze(e);Yt[r]=(Yt[r]||0)+1;var n="".concat(r,"-").concat(function(e){return Me(Fe(e)>>>0)}(Ce+r+Yt[r]));return t?"".concat(t,"-").concat(n):n}(n.displayName,n.parentComponentId):u,h=n.displayName,m=void 0===h?Be(o=r)?"styled.".concat(o):"Styled(".concat(function(e){return e.displayName||e.name||"Component"}(o),")"):h,p=n.displayName&&n.componentId?"".concat(ze(n.displayName),"-").concat(n.componentId):n.componentId||f,g=a&&s.attrs?s.attrs.concat(d).filter(Boolean):d,y=n.shouldForwardProp;if(a&&s.shouldForwardProp){var v=s.shouldForwardProp;if(n.shouldForwardProp){var x=n.shouldForwardProp;y=function(e,t){return v(e,t)&&x(e,t)}}else y=v}var w=new Ht(i,p,a?s.componentStyle:void 0);function b(r,n){return function(r,n,i){var o=r.attrs,a=r.componentStyle,s=r.defaultProps,c=r.foldedComponentIds,l=r.styledComponentId,d=r.target,u=t.useContext(Wt),f=Ot(),h=r.shouldForwardProp||f.shouldForwardProp,m=function(e,t,r){return void 0===r&&(r=Ne),e.theme!==r.theme&&e.theme||t||r.theme}(n,u,s)||Ne,p=function(e,t,r){for(var n,i=S(S({},t),{className:void 0,theme:r}),o=0;o<e.length;o+=1){var a=nt(n=e[o])?n(i):n;for(var s in a)i[s]="className"===s?ot(i[s],a[s]):"style"===s?S(S({},i[s]),a[s]):a[s]}return t.className&&(i.className=ot(i.className,t.className)),i}(o,n,m),g=p.as||d,y={};for(var v in p)void 0===p[v]||"$"===v[0]||"as"===v||"theme"===v&&p.theme===m||("forwardedAs"===v?y.as=p.forwardedAs:h&&!h(v,g)||(y[v]=p[v]));var x,w,b,j=(x=a,w=p,b=Ot(),x.generateAndInjectStyles(w,b.styleSheet,b.stylis)),k=ot(c,l);return j&&(k+=" "+j),p.className&&(k+=" "+p.className),y[Be(g)&&!$e.has(g)?"class":"className"]=k,i&&(y.ref=i),e.createElement(g,y)}(j,r,n)}b.displayName=m;var j=t.forwardRef(b);return j.attrs=g,j.componentStyle=w,j.displayName=m,j.shouldForwardProp=y,j.foldedComponentIds=a?ot(s.foldedComponentIds,s.styledComponentId):"",j.styledComponentId=p,j.target=a?s.target:r,Object.defineProperty(j,"defaultProps",{get:function(){return this._foldedDefaultProps},set:function(e){this._foldedDefaultProps=a?function(e){for(var t=[],r=1;r<arguments.length;r++)t[r-1]=arguments[r];for(var n=0,i=t;n<i.length;n++)ct(e,i[n],!0);return e}({},s.defaultProps,e):e}}),lt(j,function(){return".".concat(j.styledComponentId)}),c&&rt(j,r,{attrs:!0,componentStyle:!0,displayName:!0,foldedComponentIds:!0,shouldForwardProp:!0,styledComponentId:!0,target:!0}),j}function qt(e,t){for(var r=[e[0]],n=0,i=t.length;n<i;n+=1)r.push(t[n],e[n+1]);return r}var Qt=function(e){return Object.assign(e,{isCss:!0})};function Jt(e){for(var t=[],r=1;r<arguments.length;r++)t[r-1]=arguments[r];if(nt(e)||st(e))return Qt(Bt(qt(Ae,j([e],t,!0))));var n=e;return 0===t.length&&1===n.length&&"string"==typeof n[0]?Bt(n):Qt(Bt(qt(n,t)))}function Xt(e,t,r){if(void 0===r&&(r=Ne),!t)throw dt(1,t);var n=function(n){for(var i=[],o=1;o<arguments.length;o++)i[o-1]=arguments[o];return e(t,r,Jt.apply(void 0,j([n],i,!1)))};return n.attrs=function(n){return Xt(e,t,S(S({},r),{attrs:Array.prototype.concat(r.attrs,n).filter(Boolean)}))},n.withConfig=function(n){return Xt(e,t,S(S({},r),n))},n}var Vt=function(e){return Xt(Ut,e)},Zt=Vt;$e.forEach(function(e){Zt[e]=Vt(e)});const Kt=()=>!window.invokeNative,er=window.GetParentResourceName?window.GetParentResourceName():"zs-boilerplate";async function tr({path:e,payload:t,delay:r,mockData:n}){const i=Kt();if(i&&n)return r&&await(e=>new Promise(t=>{setTimeout(()=>{t(!0)},e)}))(r),n;const o=await fetch(`https://${er}/${e}`,{method:"post",headers:{"Content-Type":"application/json; charset=UTF-8"},body:JSON.stringify(t)});return await o.json()}function rr(t,r){e.useEffect(()=>{const e=e=>{const{action:n,data:i}=e.data;n===t&&r(i)};return Kt()||window.addEventListener("message",e),()=>{Kt()||window.removeEventListener("message",e)}},[t,r])}const nr=e=>w.jsx("svg",{xmlns:"http://www.w3.org/2000/svg",width:"1.5rem",height:"1.5rem",fill:"none",viewBox:"0 0 24 24",...e,children:w.jsx("path",{fill:"var(--main-500)",d:"M7.169 2.947 5.322 1.1C2.222 3.464.18 7.106 0 11.24h2.583A10.9 10.9 0 0 1 7.17 2.947m16.004 8.293h2.583c-.194-4.134-2.235-7.776-5.322-10.14L18.6 2.947a10.97 10.97 0 0 1 4.572 8.293m-2.545.645c0-3.965-2.118-7.285-5.813-8.163v-.878A1.935 1.935 0 0 0 12.878.906a1.935 1.935 0 0 0-1.938 1.938v.878c-3.707.878-5.812 4.185-5.812 8.163v6.459l-2.583 2.583v1.292H23.21v-1.292l-2.583-2.583zm-7.75 14.209c.18 0 .349-.013.517-.052a2.62 2.62 0 0 0 1.86-1.524q.193-.465.193-1.008h-5.166a2.6 2.6 0 0 0 2.596 2.584"})});function ir(e){return w.jsx("svg",{xmlns:"http://www.w3.org/2000/svg",width:"1.125rem",height:"1.25rem",fill:"none",viewBox:"0 0 18 20",...e,children:w.jsx("path",{fill:"#EAEDF1",d:"M9 0c4.97 0 9 3.98 9 8.889S12.375 20 9 20 0 13.798 0 8.889 4.03 0 9 0m0 6a3 3 0 1 0 0 6 3 3 0 0 0 0-6"})})}const or=e=>w.jsx("svg",{xmlns:"http://www.w3.org/2000/svg",width:"1.25rem",height:"1.25rem",fill:"none",viewBox:"0 0 20 20",...e,children:w.jsx("path",{fill:"#fff",d:"M16.25 15.582C18.535 13.977 20 11.516 20 8.75 20 3.918 15.523 0 10 0S0 3.918 0 8.75c0 2.762 1.465 5.227 3.75 6.832V20H7.5v-2.5h1.25V20h2.5v-2.5h1.25V20h3.75zM3.75 10a2.5 2.5 0 1 1 5 0 2.5 2.5 0 0 1-5 0m10-2.5a2.5 2.5 0 1 1 0 5 2.5 2.5 0 0 1 0-5"})});function ar(e,t){try{const r=t||(e=>({time_ago_prefix:"Há",time_now:"Agora",time_second:"segundo",time_seconds:"segundos",time_minute:"minuto",time_minutes:"minutos",time_hour:"hora",time_hours:"horas",time_day:"dia",time_days:"dias"}[e]||e));if(!e||isNaN(e)||e<=0)return r("time_now");const n=e>1e10?e:1e3*e,i=Date.now()-n;if(i<0||isNaN(i))return r("time_now");const o=Math.floor(i/1e3),a=Math.floor(o/60),s=Math.floor(a/60),c=Math.floor(s/24),l=r("time_ago_prefix");if(o<60){const e=Math.max(0,o);return`${l} ${e} ${r(1===e?"time_second":"time_seconds")}`}if(a<60){return`${l} ${a} ${r(1===a?"time_minute":"time_minutes")}`}if(s<24){return`${l} ${s} ${r(1===s?"time_hour":"time_hours")}`}return`${l} ${c} ${r(1===c?"time_day":"time_days")}`}catch(r){return(t||(e=>"time_now"===e?"Agora":e))("time_now")}}function sr(e=.05){return function(e,t=.2){return new Promise((r,n)=>{if(Kt())try{const i=new Audio(`/src/views/assets/sounds/${e}`);i.volume=Math.min(Math.max(t,0),1),i.preload="auto",i.oncanplaythrough=()=>{i.volume=Math.min(Math.max(t,0),1),i.play().then(()=>r()).catch(e=>{n(e)})},i.onerror=e=>{n(e)},i.load()}catch(i){n(i)}else r()})}("artlist2.wav",e)}const cr=e=>w.jsx("svg",{xmlns:"http://www.w3.org/2000/svg",width:"1.5rem",height:"1.5625rem",fill:"none",viewBox:"0 0 24 25",...e,children:w.jsx("path",{fill:"#EAEDF1",d:"M19 7.5v11a4 4 0 0 1-4 4H9a4 4 0 0 1-4-4v-11zm-9 3.25a.75.75 0 0 0-.75.75v7a.75.75 0 0 0 1.5 0v-7a.75.75 0 0 0-.75-.75m4 0a.75.75 0 0 0-.75.75v7a.75.75 0 0 0 1.5 0v-7a.75.75 0 0 0-.75-.75M12.93 2.5a2 2 0 0 1 1.664.89l.906 1.36h3.75a.75.75 0 0 1 0 1.5H4.75a.75.75 0 0 1 0-1.5H8.5l.906-1.36a2 2 0 0 1 1.664-.89z"})});function lr(e){try{return{id:(null==e?void 0:e.id)?String(e.id):`fallback-${Date.now()}-${Math.random()}`,type:(null==e?void 0:e.type)?String(e.type):"Notificação",title:(null==e?void 0:e.title)?String(e.title):"Sem título",location:(null==e?void 0:e.location)?String(e.location):"Localização desconhecida",timestamp:dr(null==e?void 0:e.timestamp),code:(null==e?void 0:e.code)?String(e.code):"10-00",action:(null==e?void 0:e.action)?String(e.action):void 0}}catch(t){return{id:`error-${Date.now()}`,type:"Erro",title:"Notificação inválida",location:"Sistema",timestamp:Math.floor(Date.now()/1e3),code:"10-00"}}}function dr(e){try{const t=Number(e);return isNaN(t)||t<=0?Math.floor(Date.now()/1e3):t}catch{return Math.floor(Date.now()/1e3)}}const ur=Zt.div`
  position: relative;
  background: rgba(20, 30, 40, 0.95);
  color: #fff;
  border-radius: 0.5rem;
  width: 38rem;
  min-height: 16rem;
  height: max-content;
  overflow: hidden;
  z-index: 100;
  animation: slideIn 0.3s ease-out;
  margin-bottom: 1.6rem;
  
  border-radius: var(--radius-md);
  background: var(--background-solid);

  @keyframes slideIn {
    from {
      transform: translateX(-20px);
      opacity: 0;
    }
    to {
      transform: translateX(0);
      opacity: 1;
    }
  }
`,fr=Zt.div`
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 2rem;
  border-bottom: 1px solid var(--white-opacity-50);
  background: var(--white-opacity-50);
`,hr=Zt.div`
  display: flex;
  align-items: center;
  gap: 1.8rem;
  flex: 1;
`,mr=Zt.div`
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: var(--main-500);
  font-family: Inter;
  font-size: 1.8rem;
  font-style: normal;
  font-weight: 600;
  line-height: 2.8rem; /* 155.556% */
`,pr=Zt.div`
  display: flex;
  padding: 0.2rem 1rem;
  justify-content: center;
  align-items: center;
  gap: 1rem;
  border-radius: var(--radius-sm);
  background: var(--main-700);
  color: var(--main-100);

  /* p-ui-medium */
  font-family: Inter;
  font-size: 1.6rem;
  font-style: normal;
  font-weight: 500;
  line-height: 2.4rem; /* 150% */
`,gr=Zt.div`
  padding: var(--padding-xl);
`,yr=Zt.div`
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 1.2rem;
  flex-wrap: nowrap;
  
  &:first-child {
    margin-top: 0;
  }
`,vr=Zt.div`
  display: flex;
  align-items: center;
  gap: 1.6rem;
`,xr=Zt.div`
  color: var(--white);

  /* p-ui */
  font-family: Inter;
  font-size: 1.6rem;
  font-style: normal;
  font-weight: 400;
  line-height: 2.4rem; /* 150% */
`,wr=Zt.div`
  color: var(--white-opacity-500);

  /* p-ui */
  font-family: Inter;
  font-size: 1.6rem;
  font-style: normal;
  font-weight: 400;
  line-height: 2.4rem; /* 150% */
`,br=Zt.div`
  display: flex;
  align-items: center;
  gap: 1.6rem;
  flex-shrink: 1;

  color: var(--white);

  font-family: Inter;
  font-size: 1.6rem;
  font-style: normal;
  font-weight: 400;
  line-height: 2.4rem; /* 150% */
  
  /* Truncate text */
  max-width: 100%;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 19ch;
`,Sr=Zt.button`
  background: var(--main-500);
  color: var(--main-950);
  border: none;
  border-radius: 0.25rem;
  padding: 0.25rem 0.5rem;
  font-size: 0.75rem;
  font-weight: 600;
  cursor: pointer;
  width: 9rem;
  flex-shrink: 0;

  display: flex;
  padding: 0.2rem 1rem;
  justify-content: center;
  align-items: center;
  gap: 0.5rem;
  white-space: nowrap;

  border-radius: var(--radius-sm);
  background: var(--main-500);


  color: var(--main-950);

  /* p-ui-medium */
  font-family: Inter;
  font-size: 1.6rem;
  font-style: normal;
  font-weight: 500;
  line-height: 2.4rem; /* 150% */
  &:hover {
    background: var(--main-400);
  }
`,jr=Zt.div`
  display: flex;
  align-items: center;
  justify-content: center;
  width: 1.5rem;
  height: 1.5rem;
  color: currentColor;
`,kr=Zt.div`
  display: flex;
  align-items: center;
  gap: 1.6rem;
  margin-left: 1rem;
`,Cr=Zt.button`
  background: transparent;
  border: none;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  padding: 0.5rem;
  
  &:hover {
    opacity: 0.8;
  }
`;function Ir({notification:r,onActionClick:n,autoClose:i=!0,duration:o=5e3,onClose:s,playSound:c=!1,onDelete:l}){const{t:d}=a(),u=t.useMemo(()=>{try{return lr(r)}catch(e){return{id:"error",type:"Erro",title:"Notificação inválida",location:"Sistema",timestamp:Math.floor(Date.now()/1e3),code:"10-00"}}},[r]);e.useEffect(()=>{c&&sr(.03).catch(e=>{})},[c]),e.useEffect(()=>{if(i){const e=setTimeout(()=>{s&&s()},o);return()=>clearTimeout(e)}},[i,o,s]);return w.jsxs(ur,{children:[w.jsxs(fr,{children:[w.jsxs(hr,{children:[w.jsxs(mr,{children:[w.jsx(jr,{children:w.jsx(nr,{})}),u.type||"Notificação"]}),w.jsx(pr,{children:u.code||"10-00"})]}),w.jsx(kr,{children:w.jsxs("div",{style:{display:"flex",gap:"0rem"},children:[w.jsx(Cr,{onClick:()=>{try{tr({path:"deleteNotification",payload:{id:u.id}}).catch(e=>{})}catch(e){}},children:w.jsx(jr,{children:w.jsx(cr,{})})}),w.jsx(Cr,{onClick:()=>{try{tr({path:"location",payload:{id:u.id}}).catch(e=>{})}catch(e){}},children:w.jsx(jr,{children:w.jsx(ir,{})})})]})})]}),w.jsxs(gr,{children:[w.jsxs(yr,{children:[w.jsxs(vr,{children:[w.jsx(jr,{style:{width:"1.25rem",height:"1.25rem"},children:w.jsx(or,{style:{width:"1.25rem",height:"1.25rem"}})}),w.jsx(xr,{children:u.title||"Sem título"})]}),w.jsx(wr,{children:ar(u.timestamp,d)})]}),w.jsxs(yr,{children:[w.jsxs(br,{children:[w.jsx(jr,{style:{width:"1.25rem",height:"1.25rem"},children:w.jsx(ir,{style:{width:"1.25rem",height:"1.25rem"}})}),u.location||"Localização desconhecida"]}),w.jsx("div",{style:{flexShrink:0},children:u.action&&w.jsx(Sr,{onClick:()=>{try{n(u.id)}catch(e){}},children:u.action})})]})]})]})}const Er=Zt.div`
  position: fixed;
  top: 0;
  right: 0;
  height: 100%;
  width: 50.9rem;
  color: #fff;
  padding: 4rem;
  display: flex;
  flex-direction: column;
  z-index: 1000;
  overflow: hidden;
  background: var(--background-solid);
  background-blend-mode: normal, difference, normal;

  overflow-x: hidden;
`,_r=Zt.div`
  display: flex;
  flex-direction: column;
  margin-bottom: 1.5rem;
`,Ar=Zt.h2`
  margin: 0;

  color: #FFF;

  /* h3 */
  font-family: Inter;
  font-size: 2.4rem;
  font-style: normal;
  font-weight: 600;
  line-height: 3.2rem; /* 133.333% */
  letter-spacing: -0.0144rem;
`,Nr=Zt.p`
  margin: 0;

  color: var(--white-opacity-500);

  /* subtle */
  font-family: Inter;
  font-size: 1.4rem;
  font-style: normal;
  font-weight: 400;
  line-height: 2rem; /* 142.857% */
`,$r=Zt.div`
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.2rem 2rem;
  border-radius: var(--radius-lg);
  border: 1px solid var(--white-opacity-100);
  background: var(--white-opacity-50);
  margin-bottom: 1rem;
`,Pr=Zt.div`
  color: #FFF;

  /* suble - semibold */
  font-family: Inter;
  font-size: 1.4rem;
  font-style: normal;
  font-weight: 600;
  line-height: 2rem; /* 142.857% */
`,Rr=Zt.div`
  color: var(--white-opacity-500);

  /* subtle */
  font-family: Inter;
  font-size: 1.4rem;
  font-style: normal;
  font-weight: 400;
  line-height: 2rem; /* 142.857% */
`,zr=Zt.button`
  border: none;
  padding: 1.2rem 11.55rem;
  margin: 1rem 0;
  cursor: pointer;
  transition: all 0.2s;
  width: 100%;
  color: var(--main-950);

  /* body-medium */
  font-family: Inter;
  font-size: 1.4rem;
  font-style: normal;
  font-weight: 500;
  line-height: 2.4rem; /* 171.429% */

  border-radius: var(--radius-lg);
  background: var(--main-500);
  &:hover {
    background: var(--main-400);
    color: var(--main-950);
  }
`,Or=Zt.div`
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  overflow-y: auto;
  flex: 1;
  margin-top: 0.5rem;
  padding-right: 0.5rem;
  
  &::-webkit-scrollbar {
    width: 6px;
  }
  
  &::-webkit-scrollbar-track {
    background: rgba(255, 255, 255, 0.05);
    border-radius: 3px;
  }
  
  &::-webkit-scrollbar-thumb {
    background-color: rgba(255, 255, 255, 0.2);
    border-radius: 3px;
  }
`,Dr=Zt.div`
  border-radius: var(--radius-md);
  background: var(--background-solid);
  margin-bottom: 0.5rem;
`,Mr=Zt.div`
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.5rem;
  padding: 1rem 2rem;
  border-bottom: 1px solid var(--white-opacity-50);
  background: var(--white-opacity-50);
  border-radius: 0.8rem 0.8rem 0 0;
`,Tr=Zt.div`
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: var(--main-200);
  font-size: 0.875rem;
  color: var(--main-500);
  font-family: Inter;
  font-size: 1.8rem;
  font-style: normal;
  font-weight: 600;
  line-height: 2.8rem; /* 155.556% */
`,Lr=Zt.div`
  padding: 0.2rem 1rem;
  border-radius: var(--radius-sm);
  background: var(--main-700);
  color: var(--main-100);

  /* p-ui-medium */
  font-family: Inter;
  font-size: 1.6rem;
  font-style: normal;
  font-weight: 500;
  line-height: 2.4rem; /* 150% */
  font-family: Inter;
  font-size: 1.8rem;
  font-style: normal;
  font-weight: 600;
  line-height: 2.8rem; /* 155.556% */
`,Fr=Zt.div`
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 2rem;
  display: flex;
  padding: 0 2rem;
  margin-bottom: 2rem;
`,Br=Zt.div`
  display: flex;
  align-items: center;
  gap: 1.6rem;
`,Gr=Zt.div`
  color: var(--white);

  /* p-ui */
  font-family: Inter;
  font-size: 1.6rem;
  font-style: normal;
  font-weight: 400;
  line-height: 2.4rem; /* 150% */
`,Hr=Zt.div`
  color: var(--white-opacity-500);

  /* p-ui */
  font-family: Inter;
  font-size: 1.6rem;
  font-style: normal;
  font-weight: 400;
  line-height: 2.4rem; /* 150% */
`,Wr=Zt.div`
  display: flex;
  gap: 1.6rem;
  align-items: center;
  color: var(--white);

  /* p-ui */
  font-family: Inter;
  font-size: 1.6rem;
  font-style: normal;
  font-weight: 400;
  line-height: 2.4rem; /* 150% */
`;Zt.button`
  border: none;
  border-radius: 0.25rem;
  padding: 0.25rem 0.5rem;
  font-size: 0.75rem;
  font-weight: 600;
  cursor: pointer;
  border-radius: var(--radius-sm);
  background: var(--main-500);
  color: var(--main-950);

  /* p-ui-medium */
  font-family: Inter;
  font-size: 1.6rem;
  font-style: normal;
  font-weight: 500;
  line-height: 2.4rem; /* 150% */
  &:hover {
    background: var(--main-400);
  }
`;const Yr=Zt.div`
  position: relative;
  width: 42px;
  height: 22px;
  background: var(--main-900);
  border-radius: 20px;
  cursor: pointer;
  transition: all 0.3s;
  
  &::after {
    content: '';
    position: absolute;
    width: 18px;
    height: 18px;
    border-radius: 50%;
    top: 2px;
    left: 2px;
    background: white;
    transition: all 0.3s;
  }
  
  &.active {
    background: var(--main-500);
    
    &::after {
      left: 22px;
    }
  }
`,Ur=Zt.div`
  position: absolute;
  top: 1.5rem;
  right: 1.5rem;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  display: flex;
  width: 3.2rem;
  height: 3.2rem;
  padding: 0.4rem;
  color: var(--main-100);
  border-radius: 0.6rem;
  background: var(--main-950);
  /* p-ui-medium */
  font-family: Inter;
  font-size: 1.6rem;
  font-style: normal;
  font-weight: 500;
  line-height: 2.4rem; /* 150% */
  
  &:hover {
    color: white;
  }
`,qr=Zt.div`
  display: flex;
  align-items: center;
  justify-content: center;
  width: 1.25rem;
  height: 1.25rem;
  color: currentColor;
`,Qr={listeners:{},on(e,t){return this.listeners[e]||(this.listeners[e]=[]),this.listeners[e].push(t),()=>{this.listeners[e]=this.listeners[e].filter(e=>e!==t)}},emit(e,t){this.listeners[e]&&this.listeners[e].forEach(e=>e(t))}},Jr={notifications:[],addNotification(e){try{const r=lr(e),n={...r,timestamp:r.timestamp||Math.floor(Date.now()/1e3)};this.notifications=[n,...this.notifications];try{localStorage.setItem("notificationHistory",JSON.stringify(this.notifications))}catch(t){}Qr.emit("notificationsUpdated",this.notifications)}catch(t){}},removeNotifications(e){try{if(!Array.isArray(e))return;this.notifications=this.notifications.filter(t=>!e.includes(t.id));try{localStorage.setItem("notificationHistory",JSON.stringify(this.notifications))}catch(t){}Qr.emit("notificationsUpdated",this.notifications)}catch(t){}},clearNotifications(){this.notifications=[];try{localStorage.setItem("notificationHistory",JSON.stringify(this.notifications))}catch(e){}Qr.emit("notificationsUpdated",this.notifications)},getNotifications(){return this.notifications},init(){try{const e=localStorage.getItem("notificationHistory");if(e){const t=JSON.parse(e);Array.isArray(t)&&(this.notifications=t.map(e=>{try{return lr(e)}catch(t){return null}}).filter(e=>null!==e))}}catch(e){this.notifications=[]}}};function Xr(){const[t,r]=e.useState(()=>{try{const e=localStorage.getItem("notificationAlertsEnabled");return null===e||"true"===e}catch(e){return!0}}),[n,i]=e.useState(()=>{try{const e=localStorage.getItem("notificationSoundEnabled");return null===e||"true"===e}catch(e){return!0}}),[o,s]=e.useState(Jr.getNotifications()),{t:c}=a();e.useEffect(()=>Qr.on("notificationsUpdated",e=>{s(e)}),[]),rr("removeNotifications",e=>{try{Array.isArray(e)&&Jr.removeNotifications(e)}catch(t){}}),rr("setNotificationSoundEnabled",e=>{i(e)}),rr("setNotificationAlertsEnabled",e=>{r(e)});return w.jsxs(Er,{children:[w.jsx(Ur,{onClick:()=>{Kt()||tr({path:"closeNotificationMenu",payload:{}})},children:"✕"}),w.jsxs(_r,{children:[w.jsx(Ar,{children:c("notification_menu_title")}),w.jsx(Nr,{children:c("notification_menu_subtitle")})]}),w.jsxs($r,{children:[w.jsxs("div",{children:[w.jsx(Pr,{children:c("notifications_alerts")}),w.jsx(Rr,{children:c("notifications_alerts_desc")})]}),w.jsx(Yr,{className:t?"active":"",onClick:()=>{const e=!t;if(r(e),!e&&n){i(!1);try{localStorage.setItem("notificationSoundEnabled","false")}catch(o){}Qr.emit("toggleSound",!1),Kt()||(tr({path:"toggleAlertSounds",payload:{enabled:!1}}),tr({path:"toggleSound",payload:!1}))}Kt()||tr({path:"toggleAlerts",payload:{enabled:e}}),Qr.emit("toggleAlerts",e);try{localStorage.setItem("notificationAlertsEnabled",String(e))}catch(o){}}})]}),w.jsxs($r,{children:[w.jsxs("div",{children:[w.jsx(Pr,{children:c("notifications_sounds")}),w.jsx(Rr,{children:c("notifications_sounds_desc")})]}),w.jsx(Yr,{className:n&&t?"active":"",onClick:()=>{if(!t)return;n||sr(.01).catch(e=>{});const e=!n;i(e),Kt()||(tr({path:"toggleAlertSounds",payload:{enabled:e}}),tr({path:"toggleSound",payload:e})),Qr.emit("toggleSound",e);try{localStorage.setItem("notificationSoundEnabled",String(e))}catch(r){}},style:{opacity:t?1:.5,cursor:t?"pointer":"not-allowed"}})]}),w.jsx(zr,{onClick:()=>{try{Jr.clearNotifications(),Kt()||tr({path:"clearNotifications",payload:{}}).catch(e=>{})}catch(e){}},children:c("clear_notifications")}),w.jsx(Or,{children:o.map(e=>{try{const t=lr(e);return w.jsxs(Dr,{children:[w.jsxs(Mr,{children:[w.jsxs(hr,{children:[w.jsxs(Tr,{children:[w.jsx(qr,{children:w.jsx(nr,{})}),t.type||"Notificação"]}),w.jsx(Lr,{children:t.code||"10-00"})]}),w.jsx(kr,{children:w.jsxs("div",{style:{display:"flex",gap:"0rem"},children:[w.jsx(Cr,{onClick:()=>{try{Jr.removeNotifications([t.id]),tr({path:"deleteNotification",payload:{id:t.id}}).catch(e=>{})}catch(e){}},children:w.jsx(qr,{children:w.jsx(cr,{})})}),w.jsx(Cr,{onClick:()=>{try{tr({path:"location",payload:{id:t.id}}).catch(e=>{})}catch(e){}},children:w.jsx(qr,{children:w.jsx(ir,{})})})]})})]}),w.jsxs(Fr,{children:[w.jsxs(Br,{children:[w.jsx(qr,{children:w.jsx(or,{})}),w.jsx(Gr,{children:t.title||"Sem título"})]}),w.jsx(Hr,{children:ar(t.timestamp,c)})]}),w.jsx(Fr,{children:w.jsxs(Wr,{children:[w.jsx(qr,{children:w.jsx(ir,{})}),t.location||"Localização desconhecida"]})})]},t.id)}catch(t){return null}})})]})}Jr.init();const Vr=Zt.div`
	position: relative;
	overflow: hidden;

    @media (max-width: 1900px) {
		zoom: 0.9;
	}

	@media (max-width: 1800px) {
		zoom: 0.8;
	}
	@media (max-width: 1500px) {
		zoom: 0.7;
	}
	@media (max-width: 1000px) {
		zoom: 0.5;
	}
`,Zr=Zt.div`
	position: fixed;
	bottom: 2rem;
	right: 45rem;
	transform: translateX(-50%);
	display: flex;
	gap: 1rem;
  display: inline-flex;
  padding: var(--padding-md);
  align-items: flex-start;
  gap: 1.2rem;
  border-radius: var(--radius-md);
  background: var(--background-solid);
`,Kr=Zt.button`
	background: var(--main-500);
	color: var(--main-950);
	border: none;
	border-radius: 0.5rem;
	padding: 0.5rem 1.5rem;
	font-size: 1rem;
	font-weight: 600;
	cursor: pointer;
	transition: all 0.2s;
  color: var(--main-950);
  text-align: center;
  display: flex;
  width: 9rem;
  padding: 0.6rem var(--radius-lg);
  justify-content: center;
  align-items: center;
  gap: 0.8rem;

  /* body-medium */
  font-family: Inter;
  font-size: 1.4rem;
  font-style: normal;
  font-weight: 500;
  line-height: 2.4rem; /* 171.429% */
	&:hover {
		background: var(--main-400);
	}
`,en=Zt.div`
	position: fixed;
	top: 50%;
	transform: translateY(-50%);
	left: 2rem;
	display: flex;
	flex-direction: column;
	gap: 1rem;
	z-index: 100;
	overflow: hidden;
	padding-right: 1rem;
  width: 38rem; /* Ajustar para corresponder à largura exata da notificação */
  padding-left: 0; /* Remover padding left */

  &::-webkit-scrollbar {
    display: none;
  }
`;function tn(){const[t,r]=e.useState(!1),[n,i]=e.useState([]),[o,a]=e.useState([{action:"QTA"},{action:"QTX"}]),[s,c]=e.useState(()=>{try{const e=localStorage.getItem("notificationAlertsEnabled");return null===e||"true"===e}catch(e){return!0}}),[l,d]=e.useState(()=>{try{const e=localStorage.getItem("notificationSoundEnabled");return null===e||"true"===e}catch(e){return!0}});e.useEffect(()=>{const e=Qr.on("toggleSound",e=>{d(e)}),t=Qr.on("toggleAlerts",e=>{c(e),e||i([])});return()=>{e(),t()}},[]),rr("toggleNotificationMenu",e=>{r(e)}),rr("setActionButtons",e=>{try{const t=function(e){try{return Array.isArray(e)?e.filter(e=>null==e?void 0:e.action).map(e=>({action:String(e.action)})):[]}catch(t){return[]}}(e);a(t)}catch(t){}});const u=e=>{try{const t=lr(e),r={...t,timestamp:Math.floor(Date.now()/1e3)};Jr.addNotification(r),s&&(i(e=>[r,...e].slice(0,5)),l&&sr(.03).catch(e=>{})),Kt()||tr({path:"playNotificationSound",payload:{type:t.type}}).catch(e=>{})}catch(t){}};rr("addNotification",u),e.useEffect(()=>{const e=e=>{e.detail&&u(e.detail)};return window.addEventListener("nui:addNotification",e),()=>{window.removeEventListener("nui:addNotification",e)}},[s,l]),rr("toggleSound",e=>{d(e);try{localStorage.setItem("notificationSoundEnabled",String(e))}catch(t){}}),rr("toggleAlerts",e=>{if(c(e),!e){i([]),d(!1);try{localStorage.setItem("notificationSoundEnabled","false")}catch(t){}}try{localStorage.setItem("notificationAlertsEnabled",String(e))}catch(t){}}),e.useEffect(()=>{if(Kt()){const e=setInterval(()=>{const e={id:Date.now().toString(),type:"disparo",title:"Arma de Fogo",location:"Broadway | Los Santos",timestamp:0,code:"10-11",action:"[F1] Abrir"},t=new CustomEvent("nui:addNotification",{detail:e});window.dispatchEvent(t)},3e3);return()=>clearInterval(e)}},[l,s]),e.useEffect(()=>{if(Kt()){a([{action:"QTA"},{action:"QTX"},{action:"QRU"},{action:"QTH"}])}tr({path:"getActionButtons"})},[]);const f=e=>{i(t=>t.filter(t=>t.id!==e))},h=e=>{Kt()||tr({path:"notificationAction",payload:{id:e}}),r(!0),f(e)};var m,p;return m="Escape",p=async()=>{t&&(tr({path:"closeNotificationMenu",payload:{}}),r(!1))},e.useEffect(()=>{const e=e=>{e.key===m&&p()};return window.addEventListener("keydown",e),()=>window.removeEventListener("keydown",e)},[p,m]),w.jsxs(Vr,{children:[t&&w.jsx(Xr,{}),w.jsx(en,{children:n.slice(-3).map((e,t)=>w.jsx(Ir,{notification:e,onActionClick:h,autoClose:!0,duration:5e3,onClose:()=>f(e.id),playSound:0===t&&l},e.id))}),t&&w.jsx(Zr,{children:o.map((e,t)=>w.jsx(Kr,{onClick:()=>(e=>{if(!Kt())try{tr({path:e}).catch(e=>{})}catch(t){}})(e.action),children:e.action},t))})]})}const rn="*",nn=s(e=>({cityId:"",setCityId:t=>e({cityId:t})})),on=e.createContext({url:"",isReady:!1});function an({children:t}){const[r,n]=e.useState({url:""}),[i,o]=e.useState(!!Kt());return e.useEffect(()=>{(async()=>{try{const e=(await c("getServerHost",{})).replace(/^(https?:\/\/)/,"");n({url:e}),o(!0)}catch(e){n({url:"api.santagroup.com.br"}),o(!0)}})()},[]),w.jsx(on.Provider,{value:{...r,isReady:i},children:t})}function sn(){const{cityId:t,setCityId:o}=nn(),{isReady:a}=e.useContext(on),[s,l]=e.useState("cidadenobre"),[d,u]=e.useState(!0),f=e.useCallback(async e=>{const t="https://santaimagens.roleplayrp.com/img/themes",r=e=>{const t=document.createElement("link");return t.rel="stylesheet",t.href=e,t},n=r(`${t}/${e}.css`);document.head.appendChild(n);if(!(await new Promise(e=>{n.onload=()=>e(!0),n.onerror=()=>e(!1)}))){const e=r(`${t}/Maresia.css`);document.head.appendChild(e)}},[]),h=e.useCallback(async()=>{try{const[e,t]=await Promise.all([c("getCityId",{},"Maresia"),c("getCityName",{},"cidadenobre")]);o(e),l(t)}catch(e){}finally{u(!1)}},[o]);if(e.useEffect(()=>{h()},[h]),e.useEffect(()=>{f(s)},[s,f]),!d&&a&&t)return w.jsx(r,{children:w.jsx(e.Suspense,{fallback:w.jsx(b,{}),children:w.jsx(n,{children:w.jsx(i,{children:w.jsx(i,{path:rn,element:w.jsx(tn,{})})})})})})}var cn={},ln=o;if(cn.createRoot=ln.createRoot,cn.hydrateRoot=ln.hydrateRoot,Kt()){const e=document.getElementById("root");e.style.backgroundImage="url('https://files.catbox.moe/5te7js.png')",e.style.backgroundSize="cover",e.style.backgroundRepeat="no-repeat",e.style.backgroundPosition="center",e.style.height="100vh"}cn.createRoot(document.getElementById("root")).render(w.jsx(t.StrictMode,{children:w.jsx(l,{customTheme:{borders:{main:{100:"1px solid rgba(255, 255, 255, 0.1)",200:"1px solid rgba(255, 255, 255, 0.2)",300:"1px solid rgba(255, 255, 255, 0.3)"}},colors:{main:{50:"#ff8f0026",100:"#ff8f0040",200:"#ff8f0080",300:"#ff8f00cc",400:"#ff8f00ff",500:"#ff8f00ff",600:"#ff8f00ff",700:"#ff8f00ff",800:"#ff8f00ff",900:"#ff8f00e6"}},logo:"https://example.com/logo.png",smallLogo:"https://example.com/small-logo.png",isFromHookCache:!1,images:{background:"https://example.com/background.jpg"},tag:"default"},children:w.jsx(d,{children:w.jsx(an,{children:w.jsx(sn,{})})})})}));
