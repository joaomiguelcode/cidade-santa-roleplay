function og(e,t){return t.forEach(function(n){n&&typeof n!="string"&&!Array.isArray(n)&&Object.keys(n).forEach(function(r){if(r!=="default"&&!(r in e)){var o=Object.getOwnPropertyDescriptor(n,r);Object.defineProperty(e,r,o.get?o:{enumerable:!0,get:function(){return n[r]}})}})}),Object.freeze(Object.defineProperty(e,Symbol.toStringTag,{value:"Module"}))}const o2=function(){const t=document.createElement("link").relList;if(t&&t.supports&&t.supports("modulepreload"))return;for(const o of document.querySelectorAll('link[rel="modulepreload"]'))r(o);new MutationObserver(o=>{for(const i of o)if(i.type==="childList")for(const s of i.addedNodes)s.tagName==="LINK"&&s.rel==="modulepreload"&&r(s)}).observe(document,{childList:!0,subtree:!0});function n(o){const i={};return o.integrity&&(i.integrity=o.integrity),o.referrerpolicy&&(i.referrerPolicy=o.referrerpolicy),o.crossorigin==="use-credentials"?i.credentials="include":o.crossorigin==="anonymous"?i.credentials="omit":i.credentials="same-origin",i}function r(o){if(o.ep)return;o.ep=!0;const i=n(o);fetch(o.href,i)}};o2();var v={exports:{}},fe={};/**
 * @license React
 * react.production.min.js
 *
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */var Bi=Symbol.for("react.element"),i2=Symbol.for("react.portal"),s2=Symbol.for("react.fragment"),a2=Symbol.for("react.strict_mode"),l2=Symbol.for("react.profiler"),c2=Symbol.for("react.provider"),u2=Symbol.for("react.context"),d2=Symbol.for("react.forward_ref"),f2=Symbol.for("react.suspense"),h2=Symbol.for("react.memo"),p2=Symbol.for("react.lazy"),ch=Symbol.iterator;function m2(e){return e===null||typeof e!="object"?null:(e=ch&&e[ch]||e["@@iterator"],typeof e=="function"?e:null)}var ig={isMounted:function(){return!1},enqueueForceUpdate:function(){},enqueueReplaceState:function(){},enqueueSetState:function(){}},sg=Object.assign,ag={};function Do(e,t,n){this.props=e,this.context=t,this.refs=ag,this.updater=n||ig}Do.prototype.isReactComponent={};Do.prototype.setState=function(e,t){if(typeof e!="object"&&typeof e!="function"&&e!=null)throw Error("setState(...): takes an object of state variables to update or a function which returns an object of state variables.");this.updater.enqueueSetState(this,e,t,"setState")};Do.prototype.forceUpdate=function(e){this.updater.enqueueForceUpdate(this,e,"forceUpdate")};function lg(){}lg.prototype=Do.prototype;function dd(e,t,n){this.props=e,this.context=t,this.refs=ag,this.updater=n||ig}var fd=dd.prototype=new lg;fd.constructor=dd;sg(fd,Do.prototype);fd.isPureReactComponent=!0;var uh=Array.isArray,cg=Object.prototype.hasOwnProperty,hd={current:null},ug={key:!0,ref:!0,__self:!0,__source:!0};function dg(e,t,n){var r,o={},i=null,s=null;if(t!=null)for(r in t.ref!==void 0&&(s=t.ref),t.key!==void 0&&(i=""+t.key),t)cg.call(t,r)&&!ug.hasOwnProperty(r)&&(o[r]=t[r]);var a=arguments.length-2;if(a===1)o.children=n;else if(1<a){for(var l=Array(a),c=0;c<a;c++)l[c]=arguments[c+2];o.children=l}if(e&&e.defaultProps)for(r in a=e.defaultProps,a)o[r]===void 0&&(o[r]=a[r]);return{$$typeof:Bi,type:e,key:i,ref:s,props:o,_owner:hd.current}}function g2(e,t){return{$$typeof:Bi,type:e.type,key:t,ref:e.ref,props:e.props,_owner:e._owner}}function pd(e){return typeof e=="object"&&e!==null&&e.$$typeof===Bi}function y2(e){var t={"=":"=0",":":"=2"};return"$"+e.replace(/[=:]/g,function(n){return t[n]})}var dh=/\/+/g;function Ol(e,t){return typeof e=="object"&&e!==null&&e.key!=null?y2(""+e.key):t.toString(36)}function Os(e,t,n,r,o){var i=typeof e;(i==="undefined"||i==="boolean")&&(e=null);var s=!1;if(e===null)s=!0;else switch(i){case"string":case"number":s=!0;break;case"object":switch(e.$$typeof){case Bi:case i2:s=!0}}if(s)return s=e,o=o(s),e=r===""?"."+Ol(s,0):r,uh(o)?(n="",e!=null&&(n=e.replace(dh,"$&/")+"/"),Os(o,t,n,"",function(c){return c})):o!=null&&(pd(o)&&(o=g2(o,n+(!o.key||s&&s.key===o.key?"":(""+o.key).replace(dh,"$&/")+"/")+e)),t.push(o)),1;if(s=0,r=r===""?".":r+":",uh(e))for(var a=0;a<e.length;a++){i=e[a];var l=r+Ol(i,a);s+=Os(i,t,n,l,o)}else if(l=m2(e),typeof l=="function")for(e=l.call(e),a=0;!(i=e.next()).done;)i=i.value,l=r+Ol(i,a++),s+=Os(i,t,n,l,o);else if(i==="object")throw t=String(e),Error("Objects are not valid as a React child (found: "+(t==="[object Object]"?"object with keys {"+Object.keys(e).join(", ")+"}":t)+"). If you meant to render a collection of children, use an array instead.");return s}function ns(e,t,n){if(e==null)return e;var r=[],o=0;return Os(e,r,"","",function(i){return t.call(n,i,o++)}),r}function v2(e){if(e._status===-1){var t=e._result;t=t(),t.then(function(n){(e._status===0||e._status===-1)&&(e._status=1,e._result=n)},function(n){(e._status===0||e._status===-1)&&(e._status=2,e._result=n)}),e._status===-1&&(e._status=0,e._result=t)}if(e._status===1)return e._result.default;throw e._result}var ut={current:null},As={transition:null},x2={ReactCurrentDispatcher:ut,ReactCurrentBatchConfig:As,ReactCurrentOwner:hd};function fg(){throw Error("act(...) is not supported in production builds of React.")}fe.Children={map:ns,forEach:function(e,t,n){ns(e,function(){t.apply(this,arguments)},n)},count:function(e){var t=0;return ns(e,function(){t++}),t},toArray:function(e){return ns(e,function(t){return t})||[]},only:function(e){if(!pd(e))throw Error("React.Children.only expected to receive a single React element child.");return e}};fe.Component=Do;fe.Fragment=s2;fe.Profiler=l2;fe.PureComponent=dd;fe.StrictMode=a2;fe.Suspense=f2;fe.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED=x2;fe.act=fg;fe.cloneElement=function(e,t,n){if(e==null)throw Error("React.cloneElement(...): The argument must be a React element, but you passed "+e+".");var r=sg({},e.props),o=e.key,i=e.ref,s=e._owner;if(t!=null){if(t.ref!==void 0&&(i=t.ref,s=hd.current),t.key!==void 0&&(o=""+t.key),e.type&&e.type.defaultProps)var a=e.type.defaultProps;for(l in t)cg.call(t,l)&&!ug.hasOwnProperty(l)&&(r[l]=t[l]===void 0&&a!==void 0?a[l]:t[l])}var l=arguments.length-2;if(l===1)r.children=n;else if(1<l){a=Array(l);for(var c=0;c<l;c++)a[c]=arguments[c+2];r.children=a}return{$$typeof:Bi,type:e.type,key:o,ref:i,props:r,_owner:s}};fe.createContext=function(e){return e={$$typeof:u2,_currentValue:e,_currentValue2:e,_threadCount:0,Provider:null,Consumer:null,_defaultValue:null,_globalName:null},e.Provider={$$typeof:c2,_context:e},e.Consumer=e};fe.createElement=dg;fe.createFactory=function(e){var t=dg.bind(null,e);return t.type=e,t};fe.createRef=function(){return{current:null}};fe.forwardRef=function(e){return{$$typeof:d2,render:e}};fe.isValidElement=pd;fe.lazy=function(e){return{$$typeof:p2,_payload:{_status:-1,_result:e},_init:v2}};fe.memo=function(e,t){return{$$typeof:h2,type:e,compare:t===void 0?null:t}};fe.startTransition=function(e){var t=As.transition;As.transition={};try{e()}finally{As.transition=t}};fe.unstable_act=fg;fe.useCallback=function(e,t){return ut.current.useCallback(e,t)};fe.useContext=function(e){return ut.current.useContext(e)};fe.useDebugValue=function(){};fe.useDeferredValue=function(e){return ut.current.useDeferredValue(e)};fe.useEffect=function(e,t){return ut.current.useEffect(e,t)};fe.useId=function(){return ut.current.useId()};fe.useImperativeHandle=function(e,t,n){return ut.current.useImperativeHandle(e,t,n)};fe.useInsertionEffect=function(e,t){return ut.current.useInsertionEffect(e,t)};fe.useLayoutEffect=function(e,t){return ut.current.useLayoutEffect(e,t)};fe.useMemo=function(e,t){return ut.current.useMemo(e,t)};fe.useReducer=function(e,t,n){return ut.current.useReducer(e,t,n)};fe.useRef=function(e){return ut.current.useRef(e)};fe.useState=function(e){return ut.current.useState(e)};fe.useSyncExternalStore=function(e,t,n){return ut.current.useSyncExternalStore(e,t,n)};fe.useTransition=function(){return ut.current.useTransition()};fe.version="18.3.1";v.exports=fe;var Ke=v.exports,md=og({__proto__:null,default:Ke},[v.exports]),zc={},Ra={exports:{}},kt={},hg={exports:{}},pg={};/**
 * @license React
 * scheduler.production.min.js
 *
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */(function(e){function t($,B){var G=$.length;$.push(B);e:for(;0<G;){var W=G-1>>>1,R=$[W];if(0<o(R,B))$[W]=B,$[G]=R,G=W;else break e}}function n($){return $.length===0?null:$[0]}function r($){if($.length===0)return null;var B=$[0],G=$.pop();if(G!==B){$[0]=G;e:for(var W=0,R=$.length,F=R>>>1;W<F;){var V=2*(W+1)-1,X=$[V],k=V+1,U=$[k];if(0>o(X,G))k<R&&0>o(U,X)?($[W]=U,$[k]=G,W=k):($[W]=X,$[V]=G,W=V);else if(k<R&&0>o(U,G))$[W]=U,$[k]=G,W=k;else break e}}return B}function o($,B){var G=$.sortIndex-B.sortIndex;return G!==0?G:$.id-B.id}if(typeof performance=="object"&&typeof performance.now=="function"){var i=performance;e.unstable_now=function(){return i.now()}}else{var s=Date,a=s.now();e.unstable_now=function(){return s.now()-a}}var l=[],c=[],u=1,d=null,p=3,y=!1,w=!1,x=!1,b=typeof setTimeout=="function"?setTimeout:null,g=typeof clearTimeout=="function"?clearTimeout:null,h=typeof setImmediate!="undefined"?setImmediate:null;typeof navigator!="undefined"&&navigator.scheduling!==void 0&&navigator.scheduling.isInputPending!==void 0&&navigator.scheduling.isInputPending.bind(navigator.scheduling);function m($){for(var B=n(c);B!==null;){if(B.callback===null)r(c);else if(B.startTime<=$)r(c),B.sortIndex=B.expirationTime,t(l,B);else break;B=n(c)}}function S($){if(x=!1,m($),!w)if(n(l)!==null)w=!0,z(E);else{var B=n(c);B!==null&&ee(S,B.startTime-$)}}function E($,B){w=!1,x&&(x=!1,g(O),O=-1),y=!0;var G=p;try{for(m(B),d=n(l);d!==null&&(!(d.expirationTime>B)||$&&!re());){var W=d.callback;if(typeof W=="function"){d.callback=null,p=d.priorityLevel;var R=W(d.expirationTime<=B);B=e.unstable_now(),typeof R=="function"?d.callback=R:d===n(l)&&r(l),m(B)}else r(l);d=n(l)}if(d!==null)var F=!0;else{var V=n(c);V!==null&&ee(S,V.startTime-B),F=!1}return F}finally{d=null,p=G,y=!1}}var T=!1,I=null,O=-1,L=5,_=-1;function re(){return!(e.unstable_now()-_<L)}function J(){if(I!==null){var $=e.unstable_now();_=$;var B=!0;try{B=I(!0,$)}finally{B?se():(T=!1,I=null)}}else T=!1}var se;if(typeof h=="function")se=function(){h(J)};else if(typeof MessageChannel!="undefined"){var j=new MessageChannel,Y=j.port2;j.port1.onmessage=J,se=function(){Y.postMessage(null)}}else se=function(){b(J,0)};function z($){I=$,T||(T=!0,se())}function ee($,B){O=b(function(){$(e.unstable_now())},B)}e.unstable_IdlePriority=5,e.unstable_ImmediatePriority=1,e.unstable_LowPriority=4,e.unstable_NormalPriority=3,e.unstable_Profiling=null,e.unstable_UserBlockingPriority=2,e.unstable_cancelCallback=function($){$.callback=null},e.unstable_continueExecution=function(){w||y||(w=!0,z(E))},e.unstable_forceFrameRate=function($){0>$||125<$?console.error("forceFrameRate takes a positive int between 0 and 125, forcing frame rates higher than 125 fps is not supported"):L=0<$?Math.floor(1e3/$):5},e.unstable_getCurrentPriorityLevel=function(){return p},e.unstable_getFirstCallbackNode=function(){return n(l)},e.unstable_next=function($){switch(p){case 1:case 2:case 3:var B=3;break;default:B=p}var G=p;p=B;try{return $()}finally{p=G}},e.unstable_pauseExecution=function(){},e.unstable_requestPaint=function(){},e.unstable_runWithPriority=function($,B){switch($){case 1:case 2:case 3:case 4:case 5:break;default:$=3}var G=p;p=$;try{return B()}finally{p=G}},e.unstable_scheduleCallback=function($,B,G){var W=e.unstable_now();switch(typeof G=="object"&&G!==null?(G=G.delay,G=typeof G=="number"&&0<G?W+G:W):G=W,$){case 1:var R=-1;break;case 2:R=250;break;case 5:R=1073741823;break;case 4:R=1e4;break;default:R=5e3}return R=G+R,$={id:u++,callback:B,priorityLevel:$,startTime:G,expirationTime:R,sortIndex:-1},G>W?($.sortIndex=G,t(c,$),n(l)===null&&$===n(c)&&(x?(g(O),O=-1):x=!0,ee(S,G-W))):($.sortIndex=R,t(l,$),w||y||(w=!0,z(E))),$},e.unstable_shouldYield=re,e.unstable_wrapCallback=function($){var B=p;return function(){var G=p;p=B;try{return $.apply(this,arguments)}finally{p=G}}}})(pg);hg.exports=pg;/**
 * @license React
 * react-dom.production.min.js
 *
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */var w2=v.exports,Ct=hg.exports;function N(e){for(var t="https://reactjs.org/docs/error-decoder.html?invariant="+e,n=1;n<arguments.length;n++)t+="&args[]="+encodeURIComponent(arguments[n]);return"Minified React error #"+e+"; visit "+t+" for the full message or use the non-minified dev environment for full errors and additional helpful warnings."}var mg=new Set,xi={};function Mr(e,t){xo(e,t),xo(e+"Capture",t)}function xo(e,t){for(xi[e]=t,e=0;e<t.length;e++)mg.add(t[e])}var xn=!(typeof window=="undefined"||typeof window.document=="undefined"||typeof window.document.createElement=="undefined"),Vc=Object.prototype.hasOwnProperty,b2=/^[:A-Z_a-z\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u02FF\u0370-\u037D\u037F-\u1FFF\u200C-\u200D\u2070-\u218F\u2C00-\u2FEF\u3001-\uD7FF\uF900-\uFDCF\uFDF0-\uFFFD][:A-Z_a-z\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u02FF\u0370-\u037D\u037F-\u1FFF\u200C-\u200D\u2070-\u218F\u2C00-\u2FEF\u3001-\uD7FF\uF900-\uFDCF\uFDF0-\uFFFD\-.0-9\u00B7\u0300-\u036F\u203F-\u2040]*$/,fh={},hh={};function C2(e){return Vc.call(hh,e)?!0:Vc.call(fh,e)?!1:b2.test(e)?hh[e]=!0:(fh[e]=!0,!1)}function S2(e,t,n,r){if(n!==null&&n.type===0)return!1;switch(typeof t){case"function":case"symbol":return!0;case"boolean":return r?!1:n!==null?!n.acceptsBooleans:(e=e.toLowerCase().slice(0,5),e!=="data-"&&e!=="aria-");default:return!1}}function k2(e,t,n,r){if(t===null||typeof t=="undefined"||S2(e,t,n,r))return!0;if(r)return!1;if(n!==null)switch(n.type){case 3:return!t;case 4:return t===!1;case 5:return isNaN(t);case 6:return isNaN(t)||1>t}return!1}function dt(e,t,n,r,o,i,s){this.acceptsBooleans=t===2||t===3||t===4,this.attributeName=r,this.attributeNamespace=o,this.mustUseProperty=n,this.propertyName=e,this.type=t,this.sanitizeURL=i,this.removeEmptyString=s}var Je={};"children dangerouslySetInnerHTML defaultValue defaultChecked innerHTML suppressContentEditableWarning suppressHydrationWarning style".split(" ").forEach(function(e){Je[e]=new dt(e,0,!1,e,null,!1,!1)});[["acceptCharset","accept-charset"],["className","class"],["htmlFor","for"],["httpEquiv","http-equiv"]].forEach(function(e){var t=e[0];Je[t]=new dt(t,1,!1,e[1],null,!1,!1)});["contentEditable","draggable","spellCheck","value"].forEach(function(e){Je[e]=new dt(e,2,!1,e.toLowerCase(),null,!1,!1)});["autoReverse","externalResourcesRequired","focusable","preserveAlpha"].forEach(function(e){Je[e]=new dt(e,2,!1,e,null,!1,!1)});"allowFullScreen async autoFocus autoPlay controls default defer disabled disablePictureInPicture disableRemotePlayback formNoValidate hidden loop noModule noValidate open playsInline readOnly required reversed scoped seamless itemScope".split(" ").forEach(function(e){Je[e]=new dt(e,3,!1,e.toLowerCase(),null,!1,!1)});["checked","multiple","muted","selected"].forEach(function(e){Je[e]=new dt(e,3,!0,e,null,!1,!1)});["capture","download"].forEach(function(e){Je[e]=new dt(e,4,!1,e,null,!1,!1)});["cols","rows","size","span"].forEach(function(e){Je[e]=new dt(e,6,!1,e,null,!1,!1)});["rowSpan","start"].forEach(function(e){Je[e]=new dt(e,5,!1,e.toLowerCase(),null,!1,!1)});var gd=/[\-:]([a-z])/g;function yd(e){return e[1].toUpperCase()}"accent-height alignment-baseline arabic-form baseline-shift cap-height clip-path clip-rule color-interpolation color-interpolation-filters color-profile color-rendering dominant-baseline enable-background fill-opacity fill-rule flood-color flood-opacity font-family font-size font-size-adjust font-stretch font-style font-variant font-weight glyph-name glyph-orientation-horizontal glyph-orientation-vertical horiz-adv-x horiz-origin-x image-rendering letter-spacing lighting-color marker-end marker-mid marker-start overline-position overline-thickness paint-order panose-1 pointer-events rendering-intent shape-rendering stop-color stop-opacity strikethrough-position strikethrough-thickness stroke-dasharray stroke-dashoffset stroke-linecap stroke-linejoin stroke-miterlimit stroke-opacity stroke-width text-anchor text-decoration text-rendering underline-position underline-thickness unicode-bidi unicode-range units-per-em v-alphabetic v-hanging v-ideographic v-mathematical vector-effect vert-adv-y vert-origin-x vert-origin-y word-spacing writing-mode xmlns:xlink x-height".split(" ").forEach(function(e){var t=e.replace(gd,yd);Je[t]=new dt(t,1,!1,e,null,!1,!1)});"xlink:actuate xlink:arcrole xlink:role xlink:show xlink:title xlink:type".split(" ").forEach(function(e){var t=e.replace(gd,yd);Je[t]=new dt(t,1,!1,e,"http://www.w3.org/1999/xlink",!1,!1)});["xml:base","xml:lang","xml:space"].forEach(function(e){var t=e.replace(gd,yd);Je[t]=new dt(t,1,!1,e,"http://www.w3.org/XML/1998/namespace",!1,!1)});["tabIndex","crossOrigin"].forEach(function(e){Je[e]=new dt(e,1,!1,e.toLowerCase(),null,!1,!1)});Je.xlinkHref=new dt("xlinkHref",1,!1,"xlink:href","http://www.w3.org/1999/xlink",!0,!1);["src","href","action","formAction"].forEach(function(e){Je[e]=new dt(e,1,!1,e.toLowerCase(),null,!0,!0)});function vd(e,t,n,r){var o=Je.hasOwnProperty(t)?Je[t]:null;(o!==null?o.type!==0:r||!(2<t.length)||t[0]!=="o"&&t[0]!=="O"||t[1]!=="n"&&t[1]!=="N")&&(k2(t,n,o,r)&&(n=null),r||o===null?C2(t)&&(n===null?e.removeAttribute(t):e.setAttribute(t,""+n)):o.mustUseProperty?e[o.propertyName]=n===null?o.type===3?!1:"":n:(t=o.attributeName,r=o.attributeNamespace,n===null?e.removeAttribute(t):(o=o.type,n=o===3||o===4&&n===!0?"":""+n,r?e.setAttributeNS(r,t,n):e.setAttribute(t,n))))}var Pn=w2.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED,rs=Symbol.for("react.element"),Kr=Symbol.for("react.portal"),Yr=Symbol.for("react.fragment"),xd=Symbol.for("react.strict_mode"),jc=Symbol.for("react.profiler"),gg=Symbol.for("react.provider"),yg=Symbol.for("react.context"),wd=Symbol.for("react.forward_ref"),Bc=Symbol.for("react.suspense"),Uc=Symbol.for("react.suspense_list"),bd=Symbol.for("react.memo"),In=Symbol.for("react.lazy"),vg=Symbol.for("react.offscreen"),ph=Symbol.iterator;function Lo(e){return e===null||typeof e!="object"?null:(e=ph&&e[ph]||e["@@iterator"],typeof e=="function"?e:null)}var Le=Object.assign,Al;function qo(e){if(Al===void 0)try{throw Error()}catch(n){var t=n.stack.trim().match(/\n( *(at )?)/);Al=t&&t[1]||""}return`
`+Al+e}var Dl=!1;function Ml(e,t){if(!e||Dl)return"";Dl=!0;var n=Error.prepareStackTrace;Error.prepareStackTrace=void 0;try{if(t)if(t=function(){throw Error()},Object.defineProperty(t.prototype,"props",{set:function(){throw Error()}}),typeof Reflect=="object"&&Reflect.construct){try{Reflect.construct(t,[])}catch(c){var r=c}Reflect.construct(e,[],t)}else{try{t.call()}catch(c){r=c}e.call(t.prototype)}else{try{throw Error()}catch(c){r=c}e()}}catch(c){if(c&&r&&typeof c.stack=="string"){for(var o=c.stack.split(`
`),i=r.stack.split(`
`),s=o.length-1,a=i.length-1;1<=s&&0<=a&&o[s]!==i[a];)a--;for(;1<=s&&0<=a;s--,a--)if(o[s]!==i[a]){if(s!==1||a!==1)do if(s--,a--,0>a||o[s]!==i[a]){var l=`
`+o[s].replace(" at new "," at ");return e.displayName&&l.includes("<anonymous>")&&(l=l.replace("<anonymous>",e.displayName)),l}while(1<=s&&0<=a);break}}}finally{Dl=!1,Error.prepareStackTrace=n}return(e=e?e.displayName||e.name:"")?qo(e):""}function P2(e){switch(e.tag){case 5:return qo(e.type);case 16:return qo("Lazy");case 13:return qo("Suspense");case 19:return qo("SuspenseList");case 0:case 2:case 15:return e=Ml(e.type,!1),e;case 11:return e=Ml(e.type.render,!1),e;case 1:return e=Ml(e.type,!0),e;default:return""}}function Hc(e){if(e==null)return null;if(typeof e=="function")return e.displayName||e.name||null;if(typeof e=="string")return e;switch(e){case Yr:return"Fragment";case Kr:return"Portal";case jc:return"Profiler";case xd:return"StrictMode";case Bc:return"Suspense";case Uc:return"SuspenseList"}if(typeof e=="object")switch(e.$$typeof){case yg:return(e.displayName||"Context")+".Consumer";case gg:return(e._context.displayName||"Context")+".Provider";case wd:var t=e.render;return e=e.displayName,e||(e=t.displayName||t.name||"",e=e!==""?"ForwardRef("+e+")":"ForwardRef"),e;case bd:return t=e.displayName||null,t!==null?t:Hc(e.type)||"Memo";case In:t=e._payload,e=e._init;try{return Hc(e(t))}catch{}}return null}function T2(e){var t=e.type;switch(e.tag){case 24:return"Cache";case 9:return(t.displayName||"Context")+".Consumer";case 10:return(t._context.displayName||"Context")+".Provider";case 18:return"DehydratedFragment";case 11:return e=t.render,e=e.displayName||e.name||"",t.displayName||(e!==""?"ForwardRef("+e+")":"ForwardRef");case 7:return"Fragment";case 5:return t;case 4:return"Portal";case 3:return"Root";case 6:return"Text";case 16:return Hc(t);case 8:return t===xd?"StrictMode":"Mode";case 22:return"Offscreen";case 12:return"Profiler";case 21:return"Scope";case 13:return"Suspense";case 19:return"SuspenseList";case 25:return"TracingMarker";case 1:case 0:case 17:case 2:case 14:case 15:if(typeof t=="function")return t.displayName||t.name||null;if(typeof t=="string")return t}return null}function Zn(e){switch(typeof e){case"boolean":case"number":case"string":case"undefined":return e;case"object":return e;default:return""}}function xg(e){var t=e.type;return(e=e.nodeName)&&e.toLowerCase()==="input"&&(t==="checkbox"||t==="radio")}function E2(e){var t=xg(e)?"checked":"value",n=Object.getOwnPropertyDescriptor(e.constructor.prototype,t),r=""+e[t];if(!e.hasOwnProperty(t)&&typeof n!="undefined"&&typeof n.get=="function"&&typeof n.set=="function"){var o=n.get,i=n.set;return Object.defineProperty(e,t,{configurable:!0,get:function(){return o.call(this)},set:function(s){r=""+s,i.call(this,s)}}),Object.defineProperty(e,t,{enumerable:n.enumerable}),{getValue:function(){return r},setValue:function(s){r=""+s},stopTracking:function(){e._valueTracker=null,delete e[t]}}}}function os(e){e._valueTracker||(e._valueTracker=E2(e))}function wg(e){if(!e)return!1;var t=e._valueTracker;if(!t)return!0;var n=t.getValue(),r="";return e&&(r=xg(e)?e.checked?"true":"false":e.value),e=r,e!==n?(t.setValue(e),!0):!1}function Ys(e){if(e=e||(typeof document!="undefined"?document:void 0),typeof e=="undefined")return null;try{return e.activeElement||e.body}catch{return e.body}}function Wc(e,t){var n=t.checked;return Le({},t,{defaultChecked:void 0,defaultValue:void 0,value:void 0,checked:n!=null?n:e._wrapperState.initialChecked})}function mh(e,t){var n=t.defaultValue==null?"":t.defaultValue,r=t.checked!=null?t.checked:t.defaultChecked;n=Zn(t.value!=null?t.value:n),e._wrapperState={initialChecked:r,initialValue:n,controlled:t.type==="checkbox"||t.type==="radio"?t.checked!=null:t.value!=null}}function bg(e,t){t=t.checked,t!=null&&vd(e,"checked",t,!1)}function Gc(e,t){bg(e,t);var n=Zn(t.value),r=t.type;if(n!=null)r==="number"?(n===0&&e.value===""||e.value!=n)&&(e.value=""+n):e.value!==""+n&&(e.value=""+n);else if(r==="submit"||r==="reset"){e.removeAttribute("value");return}t.hasOwnProperty("value")?Kc(e,t.type,n):t.hasOwnProperty("defaultValue")&&Kc(e,t.type,Zn(t.defaultValue)),t.checked==null&&t.defaultChecked!=null&&(e.defaultChecked=!!t.defaultChecked)}function gh(e,t,n){if(t.hasOwnProperty("value")||t.hasOwnProperty("defaultValue")){var r=t.type;if(!(r!=="submit"&&r!=="reset"||t.value!==void 0&&t.value!==null))return;t=""+e._wrapperState.initialValue,n||t===e.value||(e.value=t),e.defaultValue=t}n=e.name,n!==""&&(e.name=""),e.defaultChecked=!!e._wrapperState.initialChecked,n!==""&&(e.name=n)}function Kc(e,t,n){(t!=="number"||Ys(e.ownerDocument)!==e)&&(n==null?e.defaultValue=""+e._wrapperState.initialValue:e.defaultValue!==""+n&&(e.defaultValue=""+n))}var Zo=Array.isArray;function ho(e,t,n,r){if(e=e.options,t){t={};for(var o=0;o<n.length;o++)t["$"+n[o]]=!0;for(n=0;n<e.length;n++)o=t.hasOwnProperty("$"+e[n].value),e[n].selected!==o&&(e[n].selected=o),o&&r&&(e[n].defaultSelected=!0)}else{for(n=""+Zn(n),t=null,o=0;o<e.length;o++){if(e[o].value===n){e[o].selected=!0,r&&(e[o].defaultSelected=!0);return}t!==null||e[o].disabled||(t=e[o])}t!==null&&(t.selected=!0)}}function Yc(e,t){if(t.dangerouslySetInnerHTML!=null)throw Error(N(91));return Le({},t,{value:void 0,defaultValue:void 0,children:""+e._wrapperState.initialValue})}function yh(e,t){var n=t.value;if(n==null){if(n=t.children,t=t.defaultValue,n!=null){if(t!=null)throw Error(N(92));if(Zo(n)){if(1<n.length)throw Error(N(93));n=n[0]}t=n}t==null&&(t=""),n=t}e._wrapperState={initialValue:Zn(n)}}function Cg(e,t){var n=Zn(t.value),r=Zn(t.defaultValue);n!=null&&(n=""+n,n!==e.value&&(e.value=n),t.defaultValue==null&&e.defaultValue!==n&&(e.defaultValue=n)),r!=null&&(e.defaultValue=""+r)}function vh(e){var t=e.textContent;t===e._wrapperState.initialValue&&t!==""&&t!==null&&(e.value=t)}function Sg(e){switch(e){case"svg":return"http://www.w3.org/2000/svg";case"math":return"http://www.w3.org/1998/Math/MathML";default:return"http://www.w3.org/1999/xhtml"}}function Qc(e,t){return e==null||e==="http://www.w3.org/1999/xhtml"?Sg(t):e==="http://www.w3.org/2000/svg"&&t==="foreignObject"?"http://www.w3.org/1999/xhtml":e}var is,kg=function(e){return typeof MSApp!="undefined"&&MSApp.execUnsafeLocalFunction?function(t,n,r,o){MSApp.execUnsafeLocalFunction(function(){return e(t,n,r,o)})}:e}(function(e,t){if(e.namespaceURI!=="http://www.w3.org/2000/svg"||"innerHTML"in e)e.innerHTML=t;else{for(is=is||document.createElement("div"),is.innerHTML="<svg>"+t.valueOf().toString()+"</svg>",t=is.firstChild;e.firstChild;)e.removeChild(e.firstChild);for(;t.firstChild;)e.appendChild(t.firstChild)}});function wi(e,t){if(t){var n=e.firstChild;if(n&&n===e.lastChild&&n.nodeType===3){n.nodeValue=t;return}}e.textContent=t}var ri={animationIterationCount:!0,aspectRatio:!0,borderImageOutset:!0,borderImageSlice:!0,borderImageWidth:!0,boxFlex:!0,boxFlexGroup:!0,boxOrdinalGroup:!0,columnCount:!0,columns:!0,flex:!0,flexGrow:!0,flexPositive:!0,flexShrink:!0,flexNegative:!0,flexOrder:!0,gridArea:!0,gridRow:!0,gridRowEnd:!0,gridRowSpan:!0,gridRowStart:!0,gridColumn:!0,gridColumnEnd:!0,gridColumnSpan:!0,gridColumnStart:!0,fontWeight:!0,lineClamp:!0,lineHeight:!0,opacity:!0,order:!0,orphans:!0,tabSize:!0,widows:!0,zIndex:!0,zoom:!0,fillOpacity:!0,floodOpacity:!0,stopOpacity:!0,strokeDasharray:!0,strokeDashoffset:!0,strokeMiterlimit:!0,strokeOpacity:!0,strokeWidth:!0},I2=["Webkit","ms","Moz","O"];Object.keys(ri).forEach(function(e){I2.forEach(function(t){t=t+e.charAt(0).toUpperCase()+e.substring(1),ri[t]=ri[e]})});function Pg(e,t,n){return t==null||typeof t=="boolean"||t===""?"":n||typeof t!="number"||t===0||ri.hasOwnProperty(e)&&ri[e]?(""+t).trim():t+"px"}function Tg(e,t){e=e.style;for(var n in t)if(t.hasOwnProperty(n)){var r=n.indexOf("--")===0,o=Pg(n,t[n],r);n==="float"&&(n="cssFloat"),r?e.setProperty(n,o):e[n]=o}}var O2=Le({menuitem:!0},{area:!0,base:!0,br:!0,col:!0,embed:!0,hr:!0,img:!0,input:!0,keygen:!0,link:!0,meta:!0,param:!0,source:!0,track:!0,wbr:!0});function Xc(e,t){if(t){if(O2[e]&&(t.children!=null||t.dangerouslySetInnerHTML!=null))throw Error(N(137,e));if(t.dangerouslySetInnerHTML!=null){if(t.children!=null)throw Error(N(60));if(typeof t.dangerouslySetInnerHTML!="object"||!("__html"in t.dangerouslySetInnerHTML))throw Error(N(61))}if(t.style!=null&&typeof t.style!="object")throw Error(N(62))}}function qc(e,t){if(e.indexOf("-")===-1)return typeof t.is=="string";switch(e){case"annotation-xml":case"color-profile":case"font-face":case"font-face-src":case"font-face-uri":case"font-face-format":case"font-face-name":case"missing-glyph":return!1;default:return!0}}var Zc=null;function Cd(e){return e=e.target||e.srcElement||window,e.correspondingUseElement&&(e=e.correspondingUseElement),e.nodeType===3?e.parentNode:e}var Jc=null,po=null,mo=null;function xh(e){if(e=Wi(e)){if(typeof Jc!="function")throw Error(N(280));var t=e.stateNode;t&&(t=Fa(t),Jc(e.stateNode,e.type,t))}}function Eg(e){po?mo?mo.push(e):mo=[e]:po=e}function Ig(){if(po){var e=po,t=mo;if(mo=po=null,xh(e),t)for(e=0;e<t.length;e++)xh(t[e])}}function Og(e,t){return e(t)}function Ag(){}var Rl=!1;function Dg(e,t,n){if(Rl)return e(t,n);Rl=!0;try{return Og(e,t,n)}finally{Rl=!1,(po!==null||mo!==null)&&(Ag(),Ig())}}function bi(e,t){var n=e.stateNode;if(n===null)return null;var r=Fa(n);if(r===null)return null;n=r[t];e:switch(t){case"onClick":case"onClickCapture":case"onDoubleClick":case"onDoubleClickCapture":case"onMouseDown":case"onMouseDownCapture":case"onMouseMove":case"onMouseMoveCapture":case"onMouseUp":case"onMouseUpCapture":case"onMouseEnter":(r=!r.disabled)||(e=e.type,r=!(e==="button"||e==="input"||e==="select"||e==="textarea")),e=!r;break e;default:e=!1}if(e)return null;if(n&&typeof n!="function")throw Error(N(231,t,typeof n));return n}var eu=!1;if(xn)try{var No={};Object.defineProperty(No,"passive",{get:function(){eu=!0}}),window.addEventListener("test",No,No),window.removeEventListener("test",No,No)}catch{eu=!1}function A2(e,t,n,r,o,i,s,a,l){var c=Array.prototype.slice.call(arguments,3);try{t.apply(n,c)}catch(u){this.onError(u)}}var oi=!1,Qs=null,Xs=!1,tu=null,D2={onError:function(e){oi=!0,Qs=e}};function M2(e,t,n,r,o,i,s,a,l){oi=!1,Qs=null,A2.apply(D2,arguments)}function R2(e,t,n,r,o,i,s,a,l){if(M2.apply(this,arguments),oi){if(oi){var c=Qs;oi=!1,Qs=null}else throw Error(N(198));Xs||(Xs=!0,tu=c)}}function Rr(e){var t=e,n=e;if(e.alternate)for(;t.return;)t=t.return;else{e=t;do t=e,(t.flags&4098)!==0&&(n=t.return),e=t.return;while(e)}return t.tag===3?n:null}function Mg(e){if(e.tag===13){var t=e.memoizedState;if(t===null&&(e=e.alternate,e!==null&&(t=e.memoizedState)),t!==null)return t.dehydrated}return null}function wh(e){if(Rr(e)!==e)throw Error(N(188))}function $2(e){var t=e.alternate;if(!t){if(t=Rr(e),t===null)throw Error(N(188));return t!==e?null:e}for(var n=e,r=t;;){var o=n.return;if(o===null)break;var i=o.alternate;if(i===null){if(r=o.return,r!==null){n=r;continue}break}if(o.child===i.child){for(i=o.child;i;){if(i===n)return wh(o),e;if(i===r)return wh(o),t;i=i.sibling}throw Error(N(188))}if(n.return!==r.return)n=o,r=i;else{for(var s=!1,a=o.child;a;){if(a===n){s=!0,n=o,r=i;break}if(a===r){s=!0,r=o,n=i;break}a=a.sibling}if(!s){for(a=i.child;a;){if(a===n){s=!0,n=i,r=o;break}if(a===r){s=!0,r=i,n=o;break}a=a.sibling}if(!s)throw Error(N(189))}}if(n.alternate!==r)throw Error(N(190))}if(n.tag!==3)throw Error(N(188));return n.stateNode.current===n?e:t}function Rg(e){return e=$2(e),e!==null?$g(e):null}function $g(e){if(e.tag===5||e.tag===6)return e;for(e=e.child;e!==null;){var t=$g(e);if(t!==null)return t;e=e.sibling}return null}var Lg=Ct.unstable_scheduleCallback,bh=Ct.unstable_cancelCallback,L2=Ct.unstable_shouldYield,N2=Ct.unstable_requestPaint,ze=Ct.unstable_now,_2=Ct.unstable_getCurrentPriorityLevel,Sd=Ct.unstable_ImmediatePriority,Ng=Ct.unstable_UserBlockingPriority,qs=Ct.unstable_NormalPriority,F2=Ct.unstable_LowPriority,_g=Ct.unstable_IdlePriority,$a=null,on=null;function z2(e){if(on&&typeof on.onCommitFiberRoot=="function")try{on.onCommitFiberRoot($a,e,void 0,(e.current.flags&128)===128)}catch{}}var Qt=Math.clz32?Math.clz32:B2,V2=Math.log,j2=Math.LN2;function B2(e){return e>>>=0,e===0?32:31-(V2(e)/j2|0)|0}var ss=64,as=4194304;function Jo(e){switch(e&-e){case 1:return 1;case 2:return 2;case 4:return 4;case 8:return 8;case 16:return 16;case 32:return 32;case 64:case 128:case 256:case 512:case 1024:case 2048:case 4096:case 8192:case 16384:case 32768:case 65536:case 131072:case 262144:case 524288:case 1048576:case 2097152:return e&4194240;case 4194304:case 8388608:case 16777216:case 33554432:case 67108864:return e&130023424;case 134217728:return 134217728;case 268435456:return 268435456;case 536870912:return 536870912;case 1073741824:return 1073741824;default:return e}}function Zs(e,t){var n=e.pendingLanes;if(n===0)return 0;var r=0,o=e.suspendedLanes,i=e.pingedLanes,s=n&268435455;if(s!==0){var a=s&~o;a!==0?r=Jo(a):(i&=s,i!==0&&(r=Jo(i)))}else s=n&~o,s!==0?r=Jo(s):i!==0&&(r=Jo(i));if(r===0)return 0;if(t!==0&&t!==r&&(t&o)===0&&(o=r&-r,i=t&-t,o>=i||o===16&&(i&4194240)!==0))return t;if((r&4)!==0&&(r|=n&16),t=e.entangledLanes,t!==0)for(e=e.entanglements,t&=r;0<t;)n=31-Qt(t),o=1<<n,r|=e[n],t&=~o;return r}function U2(e,t){switch(e){case 1:case 2:case 4:return t+250;case 8:case 16:case 32:case 64:case 128:case 256:case 512:case 1024:case 2048:case 4096:case 8192:case 16384:case 32768:case 65536:case 131072:case 262144:case 524288:case 1048576:case 2097152:return t+5e3;case 4194304:case 8388608:case 16777216:case 33554432:case 67108864:return-1;case 134217728:case 268435456:case 536870912:case 1073741824:return-1;default:return-1}}function H2(e,t){for(var n=e.suspendedLanes,r=e.pingedLanes,o=e.expirationTimes,i=e.pendingLanes;0<i;){var s=31-Qt(i),a=1<<s,l=o[s];l===-1?((a&n)===0||(a&r)!==0)&&(o[s]=U2(a,t)):l<=t&&(e.expiredLanes|=a),i&=~a}}function nu(e){return e=e.pendingLanes&-1073741825,e!==0?e:e&1073741824?1073741824:0}function Fg(){var e=ss;return ss<<=1,(ss&4194240)===0&&(ss=64),e}function $l(e){for(var t=[],n=0;31>n;n++)t.push(e);return t}function Ui(e,t,n){e.pendingLanes|=t,t!==536870912&&(e.suspendedLanes=0,e.pingedLanes=0),e=e.eventTimes,t=31-Qt(t),e[t]=n}function W2(e,t){var n=e.pendingLanes&~t;e.pendingLanes=t,e.suspendedLanes=0,e.pingedLanes=0,e.expiredLanes&=t,e.mutableReadLanes&=t,e.entangledLanes&=t,t=e.entanglements;var r=e.eventTimes;for(e=e.expirationTimes;0<n;){var o=31-Qt(n),i=1<<o;t[o]=0,r[o]=-1,e[o]=-1,n&=~i}}function kd(e,t){var n=e.entangledLanes|=t;for(e=e.entanglements;n;){var r=31-Qt(n),o=1<<r;o&t|e[r]&t&&(e[r]|=t),n&=~o}}var ye=0;function zg(e){return e&=-e,1<e?4<e?(e&268435455)!==0?16:536870912:4:1}var Vg,Pd,jg,Bg,Ug,ru=!1,ls=[],zn=null,Vn=null,jn=null,Ci=new Map,Si=new Map,Rn=[],G2="mousedown mouseup touchcancel touchend touchstart auxclick dblclick pointercancel pointerdown pointerup dragend dragstart drop compositionend compositionstart keydown keypress keyup input textInput copy cut paste click change contextmenu reset submit".split(" ");function Ch(e,t){switch(e){case"focusin":case"focusout":zn=null;break;case"dragenter":case"dragleave":Vn=null;break;case"mouseover":case"mouseout":jn=null;break;case"pointerover":case"pointerout":Ci.delete(t.pointerId);break;case"gotpointercapture":case"lostpointercapture":Si.delete(t.pointerId)}}function _o(e,t,n,r,o,i){return e===null||e.nativeEvent!==i?(e={blockedOn:t,domEventName:n,eventSystemFlags:r,nativeEvent:i,targetContainers:[o]},t!==null&&(t=Wi(t),t!==null&&Pd(t)),e):(e.eventSystemFlags|=r,t=e.targetContainers,o!==null&&t.indexOf(o)===-1&&t.push(o),e)}function K2(e,t,n,r,o){switch(t){case"focusin":return zn=_o(zn,e,t,n,r,o),!0;case"dragenter":return Vn=_o(Vn,e,t,n,r,o),!0;case"mouseover":return jn=_o(jn,e,t,n,r,o),!0;case"pointerover":var i=o.pointerId;return Ci.set(i,_o(Ci.get(i)||null,e,t,n,r,o)),!0;case"gotpointercapture":return i=o.pointerId,Si.set(i,_o(Si.get(i)||null,e,t,n,r,o)),!0}return!1}function Hg(e){var t=yr(e.target);if(t!==null){var n=Rr(t);if(n!==null){if(t=n.tag,t===13){if(t=Mg(n),t!==null){e.blockedOn=t,Ug(e.priority,function(){jg(n)});return}}else if(t===3&&n.stateNode.current.memoizedState.isDehydrated){e.blockedOn=n.tag===3?n.stateNode.containerInfo:null;return}}}e.blockedOn=null}function Ds(e){if(e.blockedOn!==null)return!1;for(var t=e.targetContainers;0<t.length;){var n=ou(e.domEventName,e.eventSystemFlags,t[0],e.nativeEvent);if(n===null){n=e.nativeEvent;var r=new n.constructor(n.type,n);Zc=r,n.target.dispatchEvent(r),Zc=null}else return t=Wi(n),t!==null&&Pd(t),e.blockedOn=n,!1;t.shift()}return!0}function Sh(e,t,n){Ds(e)&&n.delete(t)}function Y2(){ru=!1,zn!==null&&Ds(zn)&&(zn=null),Vn!==null&&Ds(Vn)&&(Vn=null),jn!==null&&Ds(jn)&&(jn=null),Ci.forEach(Sh),Si.forEach(Sh)}function Fo(e,t){e.blockedOn===t&&(e.blockedOn=null,ru||(ru=!0,Ct.unstable_scheduleCallback(Ct.unstable_NormalPriority,Y2)))}function ki(e){function t(o){return Fo(o,e)}if(0<ls.length){Fo(ls[0],e);for(var n=1;n<ls.length;n++){var r=ls[n];r.blockedOn===e&&(r.blockedOn=null)}}for(zn!==null&&Fo(zn,e),Vn!==null&&Fo(Vn,e),jn!==null&&Fo(jn,e),Ci.forEach(t),Si.forEach(t),n=0;n<Rn.length;n++)r=Rn[n],r.blockedOn===e&&(r.blockedOn=null);for(;0<Rn.length&&(n=Rn[0],n.blockedOn===null);)Hg(n),n.blockedOn===null&&Rn.shift()}var go=Pn.ReactCurrentBatchConfig,Js=!0;function Q2(e,t,n,r){var o=ye,i=go.transition;go.transition=null;try{ye=1,Td(e,t,n,r)}finally{ye=o,go.transition=i}}function X2(e,t,n,r){var o=ye,i=go.transition;go.transition=null;try{ye=4,Td(e,t,n,r)}finally{ye=o,go.transition=i}}function Td(e,t,n,r){if(Js){var o=ou(e,t,n,r);if(o===null)Hl(e,t,r,ea,n),Ch(e,r);else if(K2(o,e,t,n,r))r.stopPropagation();else if(Ch(e,r),t&4&&-1<G2.indexOf(e)){for(;o!==null;){var i=Wi(o);if(i!==null&&Vg(i),i=ou(e,t,n,r),i===null&&Hl(e,t,r,ea,n),i===o)break;o=i}o!==null&&r.stopPropagation()}else Hl(e,t,r,null,n)}}var ea=null;function ou(e,t,n,r){if(ea=null,e=Cd(r),e=yr(e),e!==null)if(t=Rr(e),t===null)e=null;else if(n=t.tag,n===13){if(e=Mg(t),e!==null)return e;e=null}else if(n===3){if(t.stateNode.current.memoizedState.isDehydrated)return t.tag===3?t.stateNode.containerInfo:null;e=null}else t!==e&&(e=null);return ea=e,null}function Wg(e){switch(e){case"cancel":case"click":case"close":case"contextmenu":case"copy":case"cut":case"auxclick":case"dblclick":case"dragend":case"dragstart":case"drop":case"focusin":case"focusout":case"input":case"invalid":case"keydown":case"keypress":case"keyup":case"mousedown":case"mouseup":case"paste":case"pause":case"play":case"pointercancel":case"pointerdown":case"pointerup":case"ratechange":case"reset":case"resize":case"seeked":case"submit":case"touchcancel":case"touchend":case"touchstart":case"volumechange":case"change":case"selectionchange":case"textInput":case"compositionstart":case"compositionend":case"compositionupdate":case"beforeblur":case"afterblur":case"beforeinput":case"blur":case"fullscreenchange":case"focus":case"hashchange":case"popstate":case"select":case"selectstart":return 1;case"drag":case"dragenter":case"dragexit":case"dragleave":case"dragover":case"mousemove":case"mouseout":case"mouseover":case"pointermove":case"pointerout":case"pointerover":case"scroll":case"toggle":case"touchmove":case"wheel":case"mouseenter":case"mouseleave":case"pointerenter":case"pointerleave":return 4;case"message":switch(_2()){case Sd:return 1;case Ng:return 4;case qs:case F2:return 16;case _g:return 536870912;default:return 16}default:return 16}}var Nn=null,Ed=null,Ms=null;function Gg(){if(Ms)return Ms;var e,t=Ed,n=t.length,r,o="value"in Nn?Nn.value:Nn.textContent,i=o.length;for(e=0;e<n&&t[e]===o[e];e++);var s=n-e;for(r=1;r<=s&&t[n-r]===o[i-r];r++);return Ms=o.slice(e,1<r?1-r:void 0)}function Rs(e){var t=e.keyCode;return"charCode"in e?(e=e.charCode,e===0&&t===13&&(e=13)):e=t,e===10&&(e=13),32<=e||e===13?e:0}function cs(){return!0}function kh(){return!1}function Pt(e){function t(n,r,o,i,s){this._reactName=n,this._targetInst=o,this.type=r,this.nativeEvent=i,this.target=s,this.currentTarget=null;for(var a in e)e.hasOwnProperty(a)&&(n=e[a],this[a]=n?n(i):i[a]);return this.isDefaultPrevented=(i.defaultPrevented!=null?i.defaultPrevented:i.returnValue===!1)?cs:kh,this.isPropagationStopped=kh,this}return Le(t.prototype,{preventDefault:function(){this.defaultPrevented=!0;var n=this.nativeEvent;n&&(n.preventDefault?n.preventDefault():typeof n.returnValue!="unknown"&&(n.returnValue=!1),this.isDefaultPrevented=cs)},stopPropagation:function(){var n=this.nativeEvent;n&&(n.stopPropagation?n.stopPropagation():typeof n.cancelBubble!="unknown"&&(n.cancelBubble=!0),this.isPropagationStopped=cs)},persist:function(){},isPersistent:cs}),t}var Mo={eventPhase:0,bubbles:0,cancelable:0,timeStamp:function(e){return e.timeStamp||Date.now()},defaultPrevented:0,isTrusted:0},Id=Pt(Mo),Hi=Le({},Mo,{view:0,detail:0}),q2=Pt(Hi),Ll,Nl,zo,La=Le({},Hi,{screenX:0,screenY:0,clientX:0,clientY:0,pageX:0,pageY:0,ctrlKey:0,shiftKey:0,altKey:0,metaKey:0,getModifierState:Od,button:0,buttons:0,relatedTarget:function(e){return e.relatedTarget===void 0?e.fromElement===e.srcElement?e.toElement:e.fromElement:e.relatedTarget},movementX:function(e){return"movementX"in e?e.movementX:(e!==zo&&(zo&&e.type==="mousemove"?(Ll=e.screenX-zo.screenX,Nl=e.screenY-zo.screenY):Nl=Ll=0,zo=e),Ll)},movementY:function(e){return"movementY"in e?e.movementY:Nl}}),Ph=Pt(La),Z2=Le({},La,{dataTransfer:0}),J2=Pt(Z2),ex=Le({},Hi,{relatedTarget:0}),_l=Pt(ex),tx=Le({},Mo,{animationName:0,elapsedTime:0,pseudoElement:0}),nx=Pt(tx),rx=Le({},Mo,{clipboardData:function(e){return"clipboardData"in e?e.clipboardData:window.clipboardData}}),ox=Pt(rx),ix=Le({},Mo,{data:0}),Th=Pt(ix),sx={Esc:"Escape",Spacebar:" ",Left:"ArrowLeft",Up:"ArrowUp",Right:"ArrowRight",Down:"ArrowDown",Del:"Delete",Win:"OS",Menu:"ContextMenu",Apps:"ContextMenu",Scroll:"ScrollLock",MozPrintableKey:"Unidentified"},ax={8:"Backspace",9:"Tab",12:"Clear",13:"Enter",16:"Shift",17:"Control",18:"Alt",19:"Pause",20:"CapsLock",27:"Escape",32:" ",33:"PageUp",34:"PageDown",35:"End",36:"Home",37:"ArrowLeft",38:"ArrowUp",39:"ArrowRight",40:"ArrowDown",45:"Insert",46:"Delete",112:"F1",113:"F2",114:"F3",115:"F4",116:"F5",117:"F6",118:"F7",119:"F8",120:"F9",121:"F10",122:"F11",123:"F12",144:"NumLock",145:"ScrollLock",224:"Meta"},lx={Alt:"altKey",Control:"ctrlKey",Meta:"metaKey",Shift:"shiftKey"};function cx(e){var t=this.nativeEvent;return t.getModifierState?t.getModifierState(e):(e=lx[e])?!!t[e]:!1}function Od(){return cx}var ux=Le({},Hi,{key:function(e){if(e.key){var t=sx[e.key]||e.key;if(t!=="Unidentified")return t}return e.type==="keypress"?(e=Rs(e),e===13?"Enter":String.fromCharCode(e)):e.type==="keydown"||e.type==="keyup"?ax[e.keyCode]||"Unidentified":""},code:0,location:0,ctrlKey:0,shiftKey:0,altKey:0,metaKey:0,repeat:0,locale:0,getModifierState:Od,charCode:function(e){return e.type==="keypress"?Rs(e):0},keyCode:function(e){return e.type==="keydown"||e.type==="keyup"?e.keyCode:0},which:function(e){return e.type==="keypress"?Rs(e):e.type==="keydown"||e.type==="keyup"?e.keyCode:0}}),dx=Pt(ux),fx=Le({},La,{pointerId:0,width:0,height:0,pressure:0,tangentialPressure:0,tiltX:0,tiltY:0,twist:0,pointerType:0,isPrimary:0}),Eh=Pt(fx),hx=Le({},Hi,{touches:0,targetTouches:0,changedTouches:0,altKey:0,metaKey:0,ctrlKey:0,shiftKey:0,getModifierState:Od}),px=Pt(hx),mx=Le({},Mo,{propertyName:0,elapsedTime:0,pseudoElement:0}),gx=Pt(mx),yx=Le({},La,{deltaX:function(e){return"deltaX"in e?e.deltaX:"wheelDeltaX"in e?-e.wheelDeltaX:0},deltaY:function(e){return"deltaY"in e?e.deltaY:"wheelDeltaY"in e?-e.wheelDeltaY:"wheelDelta"in e?-e.wheelDelta:0},deltaZ:0,deltaMode:0}),vx=Pt(yx),xx=[9,13,27,32],Ad=xn&&"CompositionEvent"in window,ii=null;xn&&"documentMode"in document&&(ii=document.documentMode);var wx=xn&&"TextEvent"in window&&!ii,Kg=xn&&(!Ad||ii&&8<ii&&11>=ii),Ih=String.fromCharCode(32),Oh=!1;function Yg(e,t){switch(e){case"keyup":return xx.indexOf(t.keyCode)!==-1;case"keydown":return t.keyCode!==229;case"keypress":case"mousedown":case"focusout":return!0;default:return!1}}function Qg(e){return e=e.detail,typeof e=="object"&&"data"in e?e.data:null}var Qr=!1;function bx(e,t){switch(e){case"compositionend":return Qg(t);case"keypress":return t.which!==32?null:(Oh=!0,Ih);case"textInput":return e=t.data,e===Ih&&Oh?null:e;default:return null}}function Cx(e,t){if(Qr)return e==="compositionend"||!Ad&&Yg(e,t)?(e=Gg(),Ms=Ed=Nn=null,Qr=!1,e):null;switch(e){case"paste":return null;case"keypress":if(!(t.ctrlKey||t.altKey||t.metaKey)||t.ctrlKey&&t.altKey){if(t.char&&1<t.char.length)return t.char;if(t.which)return String.fromCharCode(t.which)}return null;case"compositionend":return Kg&&t.locale!=="ko"?null:t.data;default:return null}}var Sx={color:!0,date:!0,datetime:!0,"datetime-local":!0,email:!0,month:!0,number:!0,password:!0,range:!0,search:!0,tel:!0,text:!0,time:!0,url:!0,week:!0};function Ah(e){var t=e&&e.nodeName&&e.nodeName.toLowerCase();return t==="input"?!!Sx[e.type]:t==="textarea"}function Xg(e,t,n,r){Eg(r),t=ta(t,"onChange"),0<t.length&&(n=new Id("onChange","change",null,n,r),e.push({event:n,listeners:t}))}var si=null,Pi=null;function kx(e){a1(e,0)}function Na(e){var t=Zr(e);if(wg(t))return e}function Px(e,t){if(e==="change")return t}var qg=!1;if(xn){var Fl;if(xn){var zl="oninput"in document;if(!zl){var Dh=document.createElement("div");Dh.setAttribute("oninput","return;"),zl=typeof Dh.oninput=="function"}Fl=zl}else Fl=!1;qg=Fl&&(!document.documentMode||9<document.documentMode)}function Mh(){si&&(si.detachEvent("onpropertychange",Zg),Pi=si=null)}function Zg(e){if(e.propertyName==="value"&&Na(Pi)){var t=[];Xg(t,Pi,e,Cd(e)),Dg(kx,t)}}function Tx(e,t,n){e==="focusin"?(Mh(),si=t,Pi=n,si.attachEvent("onpropertychange",Zg)):e==="focusout"&&Mh()}function Ex(e){if(e==="selectionchange"||e==="keyup"||e==="keydown")return Na(Pi)}function Ix(e,t){if(e==="click")return Na(t)}function Ox(e,t){if(e==="input"||e==="change")return Na(t)}function Ax(e,t){return e===t&&(e!==0||1/e===1/t)||e!==e&&t!==t}var qt=typeof Object.is=="function"?Object.is:Ax;function Ti(e,t){if(qt(e,t))return!0;if(typeof e!="object"||e===null||typeof t!="object"||t===null)return!1;var n=Object.keys(e),r=Object.keys(t);if(n.length!==r.length)return!1;for(r=0;r<n.length;r++){var o=n[r];if(!Vc.call(t,o)||!qt(e[o],t[o]))return!1}return!0}function Rh(e){for(;e&&e.firstChild;)e=e.firstChild;return e}function $h(e,t){var n=Rh(e);e=0;for(var r;n;){if(n.nodeType===3){if(r=e+n.textContent.length,e<=t&&r>=t)return{node:n,offset:t-e};e=r}e:{for(;n;){if(n.nextSibling){n=n.nextSibling;break e}n=n.parentNode}n=void 0}n=Rh(n)}}function Jg(e,t){return e&&t?e===t?!0:e&&e.nodeType===3?!1:t&&t.nodeType===3?Jg(e,t.parentNode):"contains"in e?e.contains(t):e.compareDocumentPosition?!!(e.compareDocumentPosition(t)&16):!1:!1}function e1(){for(var e=window,t=Ys();t instanceof e.HTMLIFrameElement;){try{var n=typeof t.contentWindow.location.href=="string"}catch{n=!1}if(n)e=t.contentWindow;else break;t=Ys(e.document)}return t}function Dd(e){var t=e&&e.nodeName&&e.nodeName.toLowerCase();return t&&(t==="input"&&(e.type==="text"||e.type==="search"||e.type==="tel"||e.type==="url"||e.type==="password")||t==="textarea"||e.contentEditable==="true")}function Dx(e){var t=e1(),n=e.focusedElem,r=e.selectionRange;if(t!==n&&n&&n.ownerDocument&&Jg(n.ownerDocument.documentElement,n)){if(r!==null&&Dd(n)){if(t=r.start,e=r.end,e===void 0&&(e=t),"selectionStart"in n)n.selectionStart=t,n.selectionEnd=Math.min(e,n.value.length);else if(e=(t=n.ownerDocument||document)&&t.defaultView||window,e.getSelection){e=e.getSelection();var o=n.textContent.length,i=Math.min(r.start,o);r=r.end===void 0?i:Math.min(r.end,o),!e.extend&&i>r&&(o=r,r=i,i=o),o=$h(n,i);var s=$h(n,r);o&&s&&(e.rangeCount!==1||e.anchorNode!==o.node||e.anchorOffset!==o.offset||e.focusNode!==s.node||e.focusOffset!==s.offset)&&(t=t.createRange(),t.setStart(o.node,o.offset),e.removeAllRanges(),i>r?(e.addRange(t),e.extend(s.node,s.offset)):(t.setEnd(s.node,s.offset),e.addRange(t)))}}for(t=[],e=n;e=e.parentNode;)e.nodeType===1&&t.push({element:e,left:e.scrollLeft,top:e.scrollTop});for(typeof n.focus=="function"&&n.focus(),n=0;n<t.length;n++)e=t[n],e.element.scrollLeft=e.left,e.element.scrollTop=e.top}}var Mx=xn&&"documentMode"in document&&11>=document.documentMode,Xr=null,iu=null,ai=null,su=!1;function Lh(e,t,n){var r=n.window===n?n.document:n.nodeType===9?n:n.ownerDocument;su||Xr==null||Xr!==Ys(r)||(r=Xr,"selectionStart"in r&&Dd(r)?r={start:r.selectionStart,end:r.selectionEnd}:(r=(r.ownerDocument&&r.ownerDocument.defaultView||window).getSelection(),r={anchorNode:r.anchorNode,anchorOffset:r.anchorOffset,focusNode:r.focusNode,focusOffset:r.focusOffset}),ai&&Ti(ai,r)||(ai=r,r=ta(iu,"onSelect"),0<r.length&&(t=new Id("onSelect","select",null,t,n),e.push({event:t,listeners:r}),t.target=Xr)))}function us(e,t){var n={};return n[e.toLowerCase()]=t.toLowerCase(),n["Webkit"+e]="webkit"+t,n["Moz"+e]="moz"+t,n}var qr={animationend:us("Animation","AnimationEnd"),animationiteration:us("Animation","AnimationIteration"),animationstart:us("Animation","AnimationStart"),transitionend:us("Transition","TransitionEnd")},Vl={},t1={};xn&&(t1=document.createElement("div").style,"AnimationEvent"in window||(delete qr.animationend.animation,delete qr.animationiteration.animation,delete qr.animationstart.animation),"TransitionEvent"in window||delete qr.transitionend.transition);function _a(e){if(Vl[e])return Vl[e];if(!qr[e])return e;var t=qr[e],n;for(n in t)if(t.hasOwnProperty(n)&&n in t1)return Vl[e]=t[n];return e}var n1=_a("animationend"),r1=_a("animationiteration"),o1=_a("animationstart"),i1=_a("transitionend"),s1=new Map,Nh="abort auxClick cancel canPlay canPlayThrough click close contextMenu copy cut drag dragEnd dragEnter dragExit dragLeave dragOver dragStart drop durationChange emptied encrypted ended error gotPointerCapture input invalid keyDown keyPress keyUp load loadedData loadedMetadata loadStart lostPointerCapture mouseDown mouseMove mouseOut mouseOver mouseUp paste pause play playing pointerCancel pointerDown pointerMove pointerOut pointerOver pointerUp progress rateChange reset resize seeked seeking stalled submit suspend timeUpdate touchCancel touchEnd touchStart volumeChange scroll toggle touchMove waiting wheel".split(" ");function nr(e,t){s1.set(e,t),Mr(t,[e])}for(var jl=0;jl<Nh.length;jl++){var Bl=Nh[jl],Rx=Bl.toLowerCase(),$x=Bl[0].toUpperCase()+Bl.slice(1);nr(Rx,"on"+$x)}nr(n1,"onAnimationEnd");nr(r1,"onAnimationIteration");nr(o1,"onAnimationStart");nr("dblclick","onDoubleClick");nr("focusin","onFocus");nr("focusout","onBlur");nr(i1,"onTransitionEnd");xo("onMouseEnter",["mouseout","mouseover"]);xo("onMouseLeave",["mouseout","mouseover"]);xo("onPointerEnter",["pointerout","pointerover"]);xo("onPointerLeave",["pointerout","pointerover"]);Mr("onChange","change click focusin focusout input keydown keyup selectionchange".split(" "));Mr("onSelect","focusout contextmenu dragend focusin keydown keyup mousedown mouseup selectionchange".split(" "));Mr("onBeforeInput",["compositionend","keypress","textInput","paste"]);Mr("onCompositionEnd","compositionend focusout keydown keypress keyup mousedown".split(" "));Mr("onCompositionStart","compositionstart focusout keydown keypress keyup mousedown".split(" "));Mr("onCompositionUpdate","compositionupdate focusout keydown keypress keyup mousedown".split(" "));var ei="abort canplay canplaythrough durationchange emptied encrypted ended error loadeddata loadedmetadata loadstart pause play playing progress ratechange resize seeked seeking stalled suspend timeupdate volumechange waiting".split(" "),Lx=new Set("cancel close invalid load scroll toggle".split(" ").concat(ei));function _h(e,t,n){var r=e.type||"unknown-event";e.currentTarget=n,R2(r,t,void 0,e),e.currentTarget=null}function a1(e,t){t=(t&4)!==0;for(var n=0;n<e.length;n++){var r=e[n],o=r.event;r=r.listeners;e:{var i=void 0;if(t)for(var s=r.length-1;0<=s;s--){var a=r[s],l=a.instance,c=a.currentTarget;if(a=a.listener,l!==i&&o.isPropagationStopped())break e;_h(o,a,c),i=l}else for(s=0;s<r.length;s++){if(a=r[s],l=a.instance,c=a.currentTarget,a=a.listener,l!==i&&o.isPropagationStopped())break e;_h(o,a,c),i=l}}}if(Xs)throw e=tu,Xs=!1,tu=null,e}function ke(e,t){var n=t[du];n===void 0&&(n=t[du]=new Set);var r=e+"__bubble";n.has(r)||(l1(t,e,2,!1),n.add(r))}function Ul(e,t,n){var r=0;t&&(r|=4),l1(n,e,r,t)}var ds="_reactListening"+Math.random().toString(36).slice(2);function Ei(e){if(!e[ds]){e[ds]=!0,mg.forEach(function(n){n!=="selectionchange"&&(Lx.has(n)||Ul(n,!1,e),Ul(n,!0,e))});var t=e.nodeType===9?e:e.ownerDocument;t===null||t[ds]||(t[ds]=!0,Ul("selectionchange",!1,t))}}function l1(e,t,n,r){switch(Wg(t)){case 1:var o=Q2;break;case 4:o=X2;break;default:o=Td}n=o.bind(null,t,n,e),o=void 0,!eu||t!=="touchstart"&&t!=="touchmove"&&t!=="wheel"||(o=!0),r?o!==void 0?e.addEventListener(t,n,{capture:!0,passive:o}):e.addEventListener(t,n,!0):o!==void 0?e.addEventListener(t,n,{passive:o}):e.addEventListener(t,n,!1)}function Hl(e,t,n,r,o){var i=r;if((t&1)===0&&(t&2)===0&&r!==null)e:for(;;){if(r===null)return;var s=r.tag;if(s===3||s===4){var a=r.stateNode.containerInfo;if(a===o||a.nodeType===8&&a.parentNode===o)break;if(s===4)for(s=r.return;s!==null;){var l=s.tag;if((l===3||l===4)&&(l=s.stateNode.containerInfo,l===o||l.nodeType===8&&l.parentNode===o))return;s=s.return}for(;a!==null;){if(s=yr(a),s===null)return;if(l=s.tag,l===5||l===6){r=i=s;continue e}a=a.parentNode}}r=r.return}Dg(function(){var c=i,u=Cd(n),d=[];e:{var p=s1.get(e);if(p!==void 0){var y=Id,w=e;switch(e){case"keypress":if(Rs(n)===0)break e;case"keydown":case"keyup":y=dx;break;case"focusin":w="focus",y=_l;break;case"focusout":w="blur",y=_l;break;case"beforeblur":case"afterblur":y=_l;break;case"click":if(n.button===2)break e;case"auxclick":case"dblclick":case"mousedown":case"mousemove":case"mouseup":case"mouseout":case"mouseover":case"contextmenu":y=Ph;break;case"drag":case"dragend":case"dragenter":case"dragexit":case"dragleave":case"dragover":case"dragstart":case"drop":y=J2;break;case"touchcancel":case"touchend":case"touchmove":case"touchstart":y=px;break;case n1:case r1:case o1:y=nx;break;case i1:y=gx;break;case"scroll":y=q2;break;case"wheel":y=vx;break;case"copy":case"cut":case"paste":y=ox;break;case"gotpointercapture":case"lostpointercapture":case"pointercancel":case"pointerdown":case"pointermove":case"pointerout":case"pointerover":case"pointerup":y=Eh}var x=(t&4)!==0,b=!x&&e==="scroll",g=x?p!==null?p+"Capture":null:p;x=[];for(var h=c,m;h!==null;){m=h;var S=m.stateNode;if(m.tag===5&&S!==null&&(m=S,g!==null&&(S=bi(h,g),S!=null&&x.push(Ii(h,S,m)))),b)break;h=h.return}0<x.length&&(p=new y(p,w,null,n,u),d.push({event:p,listeners:x}))}}if((t&7)===0){e:{if(p=e==="mouseover"||e==="pointerover",y=e==="mouseout"||e==="pointerout",p&&n!==Zc&&(w=n.relatedTarget||n.fromElement)&&(yr(w)||w[wn]))break e;if((y||p)&&(p=u.window===u?u:(p=u.ownerDocument)?p.defaultView||p.parentWindow:window,y?(w=n.relatedTarget||n.toElement,y=c,w=w?yr(w):null,w!==null&&(b=Rr(w),w!==b||w.tag!==5&&w.tag!==6)&&(w=null)):(y=null,w=c),y!==w)){if(x=Ph,S="onMouseLeave",g="onMouseEnter",h="mouse",(e==="pointerout"||e==="pointerover")&&(x=Eh,S="onPointerLeave",g="onPointerEnter",h="pointer"),b=y==null?p:Zr(y),m=w==null?p:Zr(w),p=new x(S,h+"leave",y,n,u),p.target=b,p.relatedTarget=m,S=null,yr(u)===c&&(x=new x(g,h+"enter",w,n,u),x.target=m,x.relatedTarget=b,S=x),b=S,y&&w)t:{for(x=y,g=w,h=0,m=x;m;m=zr(m))h++;for(m=0,S=g;S;S=zr(S))m++;for(;0<h-m;)x=zr(x),h--;for(;0<m-h;)g=zr(g),m--;for(;h--;){if(x===g||g!==null&&x===g.alternate)break t;x=zr(x),g=zr(g)}x=null}else x=null;y!==null&&Fh(d,p,y,x,!1),w!==null&&b!==null&&Fh(d,b,w,x,!0)}}e:{if(p=c?Zr(c):window,y=p.nodeName&&p.nodeName.toLowerCase(),y==="select"||y==="input"&&p.type==="file")var E=Px;else if(Ah(p))if(qg)E=Ox;else{E=Ex;var T=Tx}else(y=p.nodeName)&&y.toLowerCase()==="input"&&(p.type==="checkbox"||p.type==="radio")&&(E=Ix);if(E&&(E=E(e,c))){Xg(d,E,n,u);break e}T&&T(e,p,c),e==="focusout"&&(T=p._wrapperState)&&T.controlled&&p.type==="number"&&Kc(p,"number",p.value)}switch(T=c?Zr(c):window,e){case"focusin":(Ah(T)||T.contentEditable==="true")&&(Xr=T,iu=c,ai=null);break;case"focusout":ai=iu=Xr=null;break;case"mousedown":su=!0;break;case"contextmenu":case"mouseup":case"dragend":su=!1,Lh(d,n,u);break;case"selectionchange":if(Mx)break;case"keydown":case"keyup":Lh(d,n,u)}var I;if(Ad)e:{switch(e){case"compositionstart":var O="onCompositionStart";break e;case"compositionend":O="onCompositionEnd";break e;case"compositionupdate":O="onCompositionUpdate";break e}O=void 0}else Qr?Yg(e,n)&&(O="onCompositionEnd"):e==="keydown"&&n.keyCode===229&&(O="onCompositionStart");O&&(Kg&&n.locale!=="ko"&&(Qr||O!=="onCompositionStart"?O==="onCompositionEnd"&&Qr&&(I=Gg()):(Nn=u,Ed="value"in Nn?Nn.value:Nn.textContent,Qr=!0)),T=ta(c,O),0<T.length&&(O=new Th(O,e,null,n,u),d.push({event:O,listeners:T}),I?O.data=I:(I=Qg(n),I!==null&&(O.data=I)))),(I=wx?bx(e,n):Cx(e,n))&&(c=ta(c,"onBeforeInput"),0<c.length&&(u=new Th("onBeforeInput","beforeinput",null,n,u),d.push({event:u,listeners:c}),u.data=I))}a1(d,t)})}function Ii(e,t,n){return{instance:e,listener:t,currentTarget:n}}function ta(e,t){for(var n=t+"Capture",r=[];e!==null;){var o=e,i=o.stateNode;o.tag===5&&i!==null&&(o=i,i=bi(e,n),i!=null&&r.unshift(Ii(e,i,o)),i=bi(e,t),i!=null&&r.push(Ii(e,i,o))),e=e.return}return r}function zr(e){if(e===null)return null;do e=e.return;while(e&&e.tag!==5);return e||null}function Fh(e,t,n,r,o){for(var i=t._reactName,s=[];n!==null&&n!==r;){var a=n,l=a.alternate,c=a.stateNode;if(l!==null&&l===r)break;a.tag===5&&c!==null&&(a=c,o?(l=bi(n,i),l!=null&&s.unshift(Ii(n,l,a))):o||(l=bi(n,i),l!=null&&s.push(Ii(n,l,a)))),n=n.return}s.length!==0&&e.push({event:t,listeners:s})}var Nx=/\r\n?/g,_x=/\u0000|\uFFFD/g;function zh(e){return(typeof e=="string"?e:""+e).replace(Nx,`
`).replace(_x,"")}function fs(e,t,n){if(t=zh(t),zh(e)!==t&&n)throw Error(N(425))}function na(){}var au=null,lu=null;function cu(e,t){return e==="textarea"||e==="noscript"||typeof t.children=="string"||typeof t.children=="number"||typeof t.dangerouslySetInnerHTML=="object"&&t.dangerouslySetInnerHTML!==null&&t.dangerouslySetInnerHTML.__html!=null}var uu=typeof setTimeout=="function"?setTimeout:void 0,Fx=typeof clearTimeout=="function"?clearTimeout:void 0,Vh=typeof Promise=="function"?Promise:void 0,zx=typeof queueMicrotask=="function"?queueMicrotask:typeof Vh!="undefined"?function(e){return Vh.resolve(null).then(e).catch(Vx)}:uu;function Vx(e){setTimeout(function(){throw e})}function Wl(e,t){var n=t,r=0;do{var o=n.nextSibling;if(e.removeChild(n),o&&o.nodeType===8)if(n=o.data,n==="/$"){if(r===0){e.removeChild(o),ki(t);return}r--}else n!=="$"&&n!=="$?"&&n!=="$!"||r++;n=o}while(n);ki(t)}function Bn(e){for(;e!=null;e=e.nextSibling){var t=e.nodeType;if(t===1||t===3)break;if(t===8){if(t=e.data,t==="$"||t==="$!"||t==="$?")break;if(t==="/$")return null}}return e}function jh(e){e=e.previousSibling;for(var t=0;e;){if(e.nodeType===8){var n=e.data;if(n==="$"||n==="$!"||n==="$?"){if(t===0)return e;t--}else n==="/$"&&t++}e=e.previousSibling}return null}var Ro=Math.random().toString(36).slice(2),tn="__reactFiber$"+Ro,Oi="__reactProps$"+Ro,wn="__reactContainer$"+Ro,du="__reactEvents$"+Ro,jx="__reactListeners$"+Ro,Bx="__reactHandles$"+Ro;function yr(e){var t=e[tn];if(t)return t;for(var n=e.parentNode;n;){if(t=n[wn]||n[tn]){if(n=t.alternate,t.child!==null||n!==null&&n.child!==null)for(e=jh(e);e!==null;){if(n=e[tn])return n;e=jh(e)}return t}e=n,n=e.parentNode}return null}function Wi(e){return e=e[tn]||e[wn],!e||e.tag!==5&&e.tag!==6&&e.tag!==13&&e.tag!==3?null:e}function Zr(e){if(e.tag===5||e.tag===6)return e.stateNode;throw Error(N(33))}function Fa(e){return e[Oi]||null}var fu=[],Jr=-1;function rr(e){return{current:e}}function Pe(e){0>Jr||(e.current=fu[Jr],fu[Jr]=null,Jr--)}function Ce(e,t){Jr++,fu[Jr]=e.current,e.current=t}var Jn={},it=rr(Jn),mt=rr(!1),kr=Jn;function wo(e,t){var n=e.type.contextTypes;if(!n)return Jn;var r=e.stateNode;if(r&&r.__reactInternalMemoizedUnmaskedChildContext===t)return r.__reactInternalMemoizedMaskedChildContext;var o={},i;for(i in n)o[i]=t[i];return r&&(e=e.stateNode,e.__reactInternalMemoizedUnmaskedChildContext=t,e.__reactInternalMemoizedMaskedChildContext=o),o}function gt(e){return e=e.childContextTypes,e!=null}function ra(){Pe(mt),Pe(it)}function Bh(e,t,n){if(it.current!==Jn)throw Error(N(168));Ce(it,t),Ce(mt,n)}function c1(e,t,n){var r=e.stateNode;if(t=t.childContextTypes,typeof r.getChildContext!="function")return n;r=r.getChildContext();for(var o in r)if(!(o in t))throw Error(N(108,T2(e)||"Unknown",o));return Le({},n,r)}function oa(e){return e=(e=e.stateNode)&&e.__reactInternalMemoizedMergedChildContext||Jn,kr=it.current,Ce(it,e),Ce(mt,mt.current),!0}function Uh(e,t,n){var r=e.stateNode;if(!r)throw Error(N(169));n?(e=c1(e,t,kr),r.__reactInternalMemoizedMergedChildContext=e,Pe(mt),Pe(it),Ce(it,e)):Pe(mt),Ce(mt,n)}var fn=null,za=!1,Gl=!1;function u1(e){fn===null?fn=[e]:fn.push(e)}function Ux(e){za=!0,u1(e)}function or(){if(!Gl&&fn!==null){Gl=!0;var e=0,t=ye;try{var n=fn;for(ye=1;e<n.length;e++){var r=n[e];do r=r(!0);while(r!==null)}fn=null,za=!1}catch(o){throw fn!==null&&(fn=fn.slice(e+1)),Lg(Sd,or),o}finally{ye=t,Gl=!1}}return null}var eo=[],to=0,ia=null,sa=0,$t=[],Lt=0,Pr=null,hn=1,pn="";function dr(e,t){eo[to++]=sa,eo[to++]=ia,ia=e,sa=t}function d1(e,t,n){$t[Lt++]=hn,$t[Lt++]=pn,$t[Lt++]=Pr,Pr=e;var r=hn;e=pn;var o=32-Qt(r)-1;r&=~(1<<o),n+=1;var i=32-Qt(t)+o;if(30<i){var s=o-o%5;i=(r&(1<<s)-1).toString(32),r>>=s,o-=s,hn=1<<32-Qt(t)+o|n<<o|r,pn=i+e}else hn=1<<i|n<<o|r,pn=e}function Md(e){e.return!==null&&(dr(e,1),d1(e,1,0))}function Rd(e){for(;e===ia;)ia=eo[--to],eo[to]=null,sa=eo[--to],eo[to]=null;for(;e===Pr;)Pr=$t[--Lt],$t[Lt]=null,pn=$t[--Lt],$t[Lt]=null,hn=$t[--Lt],$t[Lt]=null}var bt=null,wt=null,Ie=!1,Kt=null;function f1(e,t){var n=Ft(5,null,null,0);n.elementType="DELETED",n.stateNode=t,n.return=e,t=e.deletions,t===null?(e.deletions=[n],e.flags|=16):t.push(n)}function Hh(e,t){switch(e.tag){case 5:var n=e.type;return t=t.nodeType!==1||n.toLowerCase()!==t.nodeName.toLowerCase()?null:t,t!==null?(e.stateNode=t,bt=e,wt=Bn(t.firstChild),!0):!1;case 6:return t=e.pendingProps===""||t.nodeType!==3?null:t,t!==null?(e.stateNode=t,bt=e,wt=null,!0):!1;case 13:return t=t.nodeType!==8?null:t,t!==null?(n=Pr!==null?{id:hn,overflow:pn}:null,e.memoizedState={dehydrated:t,treeContext:n,retryLane:1073741824},n=Ft(18,null,null,0),n.stateNode=t,n.return=e,e.child=n,bt=e,wt=null,!0):!1;default:return!1}}function hu(e){return(e.mode&1)!==0&&(e.flags&128)===0}function pu(e){if(Ie){var t=wt;if(t){var n=t;if(!Hh(e,t)){if(hu(e))throw Error(N(418));t=Bn(n.nextSibling);var r=bt;t&&Hh(e,t)?f1(r,n):(e.flags=e.flags&-4097|2,Ie=!1,bt=e)}}else{if(hu(e))throw Error(N(418));e.flags=e.flags&-4097|2,Ie=!1,bt=e}}}function Wh(e){for(e=e.return;e!==null&&e.tag!==5&&e.tag!==3&&e.tag!==13;)e=e.return;bt=e}function hs(e){if(e!==bt)return!1;if(!Ie)return Wh(e),Ie=!0,!1;var t;if((t=e.tag!==3)&&!(t=e.tag!==5)&&(t=e.type,t=t!=="head"&&t!=="body"&&!cu(e.type,e.memoizedProps)),t&&(t=wt)){if(hu(e))throw h1(),Error(N(418));for(;t;)f1(e,t),t=Bn(t.nextSibling)}if(Wh(e),e.tag===13){if(e=e.memoizedState,e=e!==null?e.dehydrated:null,!e)throw Error(N(317));e:{for(e=e.nextSibling,t=0;e;){if(e.nodeType===8){var n=e.data;if(n==="/$"){if(t===0){wt=Bn(e.nextSibling);break e}t--}else n!=="$"&&n!=="$!"&&n!=="$?"||t++}e=e.nextSibling}wt=null}}else wt=bt?Bn(e.stateNode.nextSibling):null;return!0}function h1(){for(var e=wt;e;)e=Bn(e.nextSibling)}function bo(){wt=bt=null,Ie=!1}function $d(e){Kt===null?Kt=[e]:Kt.push(e)}var Hx=Pn.ReactCurrentBatchConfig;function Vo(e,t,n){if(e=n.ref,e!==null&&typeof e!="function"&&typeof e!="object"){if(n._owner){if(n=n._owner,n){if(n.tag!==1)throw Error(N(309));var r=n.stateNode}if(!r)throw Error(N(147,e));var o=r,i=""+e;return t!==null&&t.ref!==null&&typeof t.ref=="function"&&t.ref._stringRef===i?t.ref:(t=function(s){var a=o.refs;s===null?delete a[i]:a[i]=s},t._stringRef=i,t)}if(typeof e!="string")throw Error(N(284));if(!n._owner)throw Error(N(290,e))}return e}function ps(e,t){throw e=Object.prototype.toString.call(t),Error(N(31,e==="[object Object]"?"object with keys {"+Object.keys(t).join(", ")+"}":e))}function Gh(e){var t=e._init;return t(e._payload)}function p1(e){function t(g,h){if(e){var m=g.deletions;m===null?(g.deletions=[h],g.flags|=16):m.push(h)}}function n(g,h){if(!e)return null;for(;h!==null;)t(g,h),h=h.sibling;return null}function r(g,h){for(g=new Map;h!==null;)h.key!==null?g.set(h.key,h):g.set(h.index,h),h=h.sibling;return g}function o(g,h){return g=Gn(g,h),g.index=0,g.sibling=null,g}function i(g,h,m){return g.index=m,e?(m=g.alternate,m!==null?(m=m.index,m<h?(g.flags|=2,h):m):(g.flags|=2,h)):(g.flags|=1048576,h)}function s(g){return e&&g.alternate===null&&(g.flags|=2),g}function a(g,h,m,S){return h===null||h.tag!==6?(h=Jl(m,g.mode,S),h.return=g,h):(h=o(h,m),h.return=g,h)}function l(g,h,m,S){var E=m.type;return E===Yr?u(g,h,m.props.children,S,m.key):h!==null&&(h.elementType===E||typeof E=="object"&&E!==null&&E.$$typeof===In&&Gh(E)===h.type)?(S=o(h,m.props),S.ref=Vo(g,h,m),S.return=g,S):(S=Vs(m.type,m.key,m.props,null,g.mode,S),S.ref=Vo(g,h,m),S.return=g,S)}function c(g,h,m,S){return h===null||h.tag!==4||h.stateNode.containerInfo!==m.containerInfo||h.stateNode.implementation!==m.implementation?(h=ec(m,g.mode,S),h.return=g,h):(h=o(h,m.children||[]),h.return=g,h)}function u(g,h,m,S,E){return h===null||h.tag!==7?(h=Cr(m,g.mode,S,E),h.return=g,h):(h=o(h,m),h.return=g,h)}function d(g,h,m){if(typeof h=="string"&&h!==""||typeof h=="number")return h=Jl(""+h,g.mode,m),h.return=g,h;if(typeof h=="object"&&h!==null){switch(h.$$typeof){case rs:return m=Vs(h.type,h.key,h.props,null,g.mode,m),m.ref=Vo(g,null,h),m.return=g,m;case Kr:return h=ec(h,g.mode,m),h.return=g,h;case In:var S=h._init;return d(g,S(h._payload),m)}if(Zo(h)||Lo(h))return h=Cr(h,g.mode,m,null),h.return=g,h;ps(g,h)}return null}function p(g,h,m,S){var E=h!==null?h.key:null;if(typeof m=="string"&&m!==""||typeof m=="number")return E!==null?null:a(g,h,""+m,S);if(typeof m=="object"&&m!==null){switch(m.$$typeof){case rs:return m.key===E?l(g,h,m,S):null;case Kr:return m.key===E?c(g,h,m,S):null;case In:return E=m._init,p(g,h,E(m._payload),S)}if(Zo(m)||Lo(m))return E!==null?null:u(g,h,m,S,null);ps(g,m)}return null}function y(g,h,m,S,E){if(typeof S=="string"&&S!==""||typeof S=="number")return g=g.get(m)||null,a(h,g,""+S,E);if(typeof S=="object"&&S!==null){switch(S.$$typeof){case rs:return g=g.get(S.key===null?m:S.key)||null,l(h,g,S,E);case Kr:return g=g.get(S.key===null?m:S.key)||null,c(h,g,S,E);case In:var T=S._init;return y(g,h,m,T(S._payload),E)}if(Zo(S)||Lo(S))return g=g.get(m)||null,u(h,g,S,E,null);ps(h,S)}return null}function w(g,h,m,S){for(var E=null,T=null,I=h,O=h=0,L=null;I!==null&&O<m.length;O++){I.index>O?(L=I,I=null):L=I.sibling;var _=p(g,I,m[O],S);if(_===null){I===null&&(I=L);break}e&&I&&_.alternate===null&&t(g,I),h=i(_,h,O),T===null?E=_:T.sibling=_,T=_,I=L}if(O===m.length)return n(g,I),Ie&&dr(g,O),E;if(I===null){for(;O<m.length;O++)I=d(g,m[O],S),I!==null&&(h=i(I,h,O),T===null?E=I:T.sibling=I,T=I);return Ie&&dr(g,O),E}for(I=r(g,I);O<m.length;O++)L=y(I,g,O,m[O],S),L!==null&&(e&&L.alternate!==null&&I.delete(L.key===null?O:L.key),h=i(L,h,O),T===null?E=L:T.sibling=L,T=L);return e&&I.forEach(function(re){return t(g,re)}),Ie&&dr(g,O),E}function x(g,h,m,S){var E=Lo(m);if(typeof E!="function")throw Error(N(150));if(m=E.call(m),m==null)throw Error(N(151));for(var T=E=null,I=h,O=h=0,L=null,_=m.next();I!==null&&!_.done;O++,_=m.next()){I.index>O?(L=I,I=null):L=I.sibling;var re=p(g,I,_.value,S);if(re===null){I===null&&(I=L);break}e&&I&&re.alternate===null&&t(g,I),h=i(re,h,O),T===null?E=re:T.sibling=re,T=re,I=L}if(_.done)return n(g,I),Ie&&dr(g,O),E;if(I===null){for(;!_.done;O++,_=m.next())_=d(g,_.value,S),_!==null&&(h=i(_,h,O),T===null?E=_:T.sibling=_,T=_);return Ie&&dr(g,O),E}for(I=r(g,I);!_.done;O++,_=m.next())_=y(I,g,O,_.value,S),_!==null&&(e&&_.alternate!==null&&I.delete(_.key===null?O:_.key),h=i(_,h,O),T===null?E=_:T.sibling=_,T=_);return e&&I.forEach(function(J){return t(g,J)}),Ie&&dr(g,O),E}function b(g,h,m,S){if(typeof m=="object"&&m!==null&&m.type===Yr&&m.key===null&&(m=m.props.children),typeof m=="object"&&m!==null){switch(m.$$typeof){case rs:e:{for(var E=m.key,T=h;T!==null;){if(T.key===E){if(E=m.type,E===Yr){if(T.tag===7){n(g,T.sibling),h=o(T,m.props.children),h.return=g,g=h;break e}}else if(T.elementType===E||typeof E=="object"&&E!==null&&E.$$typeof===In&&Gh(E)===T.type){n(g,T.sibling),h=o(T,m.props),h.ref=Vo(g,T,m),h.return=g,g=h;break e}n(g,T);break}else t(g,T);T=T.sibling}m.type===Yr?(h=Cr(m.props.children,g.mode,S,m.key),h.return=g,g=h):(S=Vs(m.type,m.key,m.props,null,g.mode,S),S.ref=Vo(g,h,m),S.return=g,g=S)}return s(g);case Kr:e:{for(T=m.key;h!==null;){if(h.key===T)if(h.tag===4&&h.stateNode.containerInfo===m.containerInfo&&h.stateNode.implementation===m.implementation){n(g,h.sibling),h=o(h,m.children||[]),h.return=g,g=h;break e}else{n(g,h);break}else t(g,h);h=h.sibling}h=ec(m,g.mode,S),h.return=g,g=h}return s(g);case In:return T=m._init,b(g,h,T(m._payload),S)}if(Zo(m))return w(g,h,m,S);if(Lo(m))return x(g,h,m,S);ps(g,m)}return typeof m=="string"&&m!==""||typeof m=="number"?(m=""+m,h!==null&&h.tag===6?(n(g,h.sibling),h=o(h,m),h.return=g,g=h):(n(g,h),h=Jl(m,g.mode,S),h.return=g,g=h),s(g)):n(g,h)}return b}var Co=p1(!0),m1=p1(!1),aa=rr(null),la=null,no=null,Ld=null;function Nd(){Ld=no=la=null}function _d(e){var t=aa.current;Pe(aa),e._currentValue=t}function mu(e,t,n){for(;e!==null;){var r=e.alternate;if((e.childLanes&t)!==t?(e.childLanes|=t,r!==null&&(r.childLanes|=t)):r!==null&&(r.childLanes&t)!==t&&(r.childLanes|=t),e===n)break;e=e.return}}function yo(e,t){la=e,Ld=no=null,e=e.dependencies,e!==null&&e.firstContext!==null&&((e.lanes&t)!==0&&(ht=!0),e.firstContext=null)}function Vt(e){var t=e._currentValue;if(Ld!==e)if(e={context:e,memoizedValue:t,next:null},no===null){if(la===null)throw Error(N(308));no=e,la.dependencies={lanes:0,firstContext:e}}else no=no.next=e;return t}var vr=null;function Fd(e){vr===null?vr=[e]:vr.push(e)}function g1(e,t,n,r){var o=t.interleaved;return o===null?(n.next=n,Fd(t)):(n.next=o.next,o.next=n),t.interleaved=n,bn(e,r)}function bn(e,t){e.lanes|=t;var n=e.alternate;for(n!==null&&(n.lanes|=t),n=e,e=e.return;e!==null;)e.childLanes|=t,n=e.alternate,n!==null&&(n.childLanes|=t),n=e,e=e.return;return n.tag===3?n.stateNode:null}var On=!1;function zd(e){e.updateQueue={baseState:e.memoizedState,firstBaseUpdate:null,lastBaseUpdate:null,shared:{pending:null,interleaved:null,lanes:0},effects:null}}function y1(e,t){e=e.updateQueue,t.updateQueue===e&&(t.updateQueue={baseState:e.baseState,firstBaseUpdate:e.firstBaseUpdate,lastBaseUpdate:e.lastBaseUpdate,shared:e.shared,effects:e.effects})}function gn(e,t){return{eventTime:e,lane:t,tag:0,payload:null,callback:null,next:null}}function Un(e,t,n){var r=e.updateQueue;if(r===null)return null;if(r=r.shared,(me&2)!==0){var o=r.pending;return o===null?t.next=t:(t.next=o.next,o.next=t),r.pending=t,bn(e,n)}return o=r.interleaved,o===null?(t.next=t,Fd(r)):(t.next=o.next,o.next=t),r.interleaved=t,bn(e,n)}function $s(e,t,n){if(t=t.updateQueue,t!==null&&(t=t.shared,(n&4194240)!==0)){var r=t.lanes;r&=e.pendingLanes,n|=r,t.lanes=n,kd(e,n)}}function Kh(e,t){var n=e.updateQueue,r=e.alternate;if(r!==null&&(r=r.updateQueue,n===r)){var o=null,i=null;if(n=n.firstBaseUpdate,n!==null){do{var s={eventTime:n.eventTime,lane:n.lane,tag:n.tag,payload:n.payload,callback:n.callback,next:null};i===null?o=i=s:i=i.next=s,n=n.next}while(n!==null);i===null?o=i=t:i=i.next=t}else o=i=t;n={baseState:r.baseState,firstBaseUpdate:o,lastBaseUpdate:i,shared:r.shared,effects:r.effects},e.updateQueue=n;return}e=n.lastBaseUpdate,e===null?n.firstBaseUpdate=t:e.next=t,n.lastBaseUpdate=t}function ca(e,t,n,r){var o=e.updateQueue;On=!1;var i=o.firstBaseUpdate,s=o.lastBaseUpdate,a=o.shared.pending;if(a!==null){o.shared.pending=null;var l=a,c=l.next;l.next=null,s===null?i=c:s.next=c,s=l;var u=e.alternate;u!==null&&(u=u.updateQueue,a=u.lastBaseUpdate,a!==s&&(a===null?u.firstBaseUpdate=c:a.next=c,u.lastBaseUpdate=l))}if(i!==null){var d=o.baseState;s=0,u=c=l=null,a=i;do{var p=a.lane,y=a.eventTime;if((r&p)===p){u!==null&&(u=u.next={eventTime:y,lane:0,tag:a.tag,payload:a.payload,callback:a.callback,next:null});e:{var w=e,x=a;switch(p=t,y=n,x.tag){case 1:if(w=x.payload,typeof w=="function"){d=w.call(y,d,p);break e}d=w;break e;case 3:w.flags=w.flags&-65537|128;case 0:if(w=x.payload,p=typeof w=="function"?w.call(y,d,p):w,p==null)break e;d=Le({},d,p);break e;case 2:On=!0}}a.callback!==null&&a.lane!==0&&(e.flags|=64,p=o.effects,p===null?o.effects=[a]:p.push(a))}else y={eventTime:y,lane:p,tag:a.tag,payload:a.payload,callback:a.callback,next:null},u===null?(c=u=y,l=d):u=u.next=y,s|=p;if(a=a.next,a===null){if(a=o.shared.pending,a===null)break;p=a,a=p.next,p.next=null,o.lastBaseUpdate=p,o.shared.pending=null}}while(1);if(u===null&&(l=d),o.baseState=l,o.firstBaseUpdate=c,o.lastBaseUpdate=u,t=o.shared.interleaved,t!==null){o=t;do s|=o.lane,o=o.next;while(o!==t)}else i===null&&(o.shared.lanes=0);Er|=s,e.lanes=s,e.memoizedState=d}}function Yh(e,t,n){if(e=t.effects,t.effects=null,e!==null)for(t=0;t<e.length;t++){var r=e[t],o=r.callback;if(o!==null){if(r.callback=null,r=n,typeof o!="function")throw Error(N(191,o));o.call(r)}}}var Gi={},sn=rr(Gi),Ai=rr(Gi),Di=rr(Gi);function xr(e){if(e===Gi)throw Error(N(174));return e}function Vd(e,t){switch(Ce(Di,t),Ce(Ai,e),Ce(sn,Gi),e=t.nodeType,e){case 9:case 11:t=(t=t.documentElement)?t.namespaceURI:Qc(null,"");break;default:e=e===8?t.parentNode:t,t=e.namespaceURI||null,e=e.tagName,t=Qc(t,e)}Pe(sn),Ce(sn,t)}function So(){Pe(sn),Pe(Ai),Pe(Di)}function v1(e){xr(Di.current);var t=xr(sn.current),n=Qc(t,e.type);t!==n&&(Ce(Ai,e),Ce(sn,n))}function jd(e){Ai.current===e&&(Pe(sn),Pe(Ai))}var Me=rr(0);function ua(e){for(var t=e;t!==null;){if(t.tag===13){var n=t.memoizedState;if(n!==null&&(n=n.dehydrated,n===null||n.data==="$?"||n.data==="$!"))return t}else if(t.tag===19&&t.memoizedProps.revealOrder!==void 0){if((t.flags&128)!==0)return t}else if(t.child!==null){t.child.return=t,t=t.child;continue}if(t===e)break;for(;t.sibling===null;){if(t.return===null||t.return===e)return null;t=t.return}t.sibling.return=t.return,t=t.sibling}return null}var Kl=[];function Bd(){for(var e=0;e<Kl.length;e++)Kl[e]._workInProgressVersionPrimary=null;Kl.length=0}var Ls=Pn.ReactCurrentDispatcher,Yl=Pn.ReactCurrentBatchConfig,Tr=0,$e=null,Ue=null,Ge=null,da=!1,li=!1,Mi=0,Wx=0;function et(){throw Error(N(321))}function Ud(e,t){if(t===null)return!1;for(var n=0;n<t.length&&n<e.length;n++)if(!qt(e[n],t[n]))return!1;return!0}function Hd(e,t,n,r,o,i){if(Tr=i,$e=t,t.memoizedState=null,t.updateQueue=null,t.lanes=0,Ls.current=e===null||e.memoizedState===null?Qx:Xx,e=n(r,o),li){i=0;do{if(li=!1,Mi=0,25<=i)throw Error(N(301));i+=1,Ge=Ue=null,t.updateQueue=null,Ls.current=qx,e=n(r,o)}while(li)}if(Ls.current=fa,t=Ue!==null&&Ue.next!==null,Tr=0,Ge=Ue=$e=null,da=!1,t)throw Error(N(300));return e}function Wd(){var e=Mi!==0;return Mi=0,e}function en(){var e={memoizedState:null,baseState:null,baseQueue:null,queue:null,next:null};return Ge===null?$e.memoizedState=Ge=e:Ge=Ge.next=e,Ge}function jt(){if(Ue===null){var e=$e.alternate;e=e!==null?e.memoizedState:null}else e=Ue.next;var t=Ge===null?$e.memoizedState:Ge.next;if(t!==null)Ge=t,Ue=e;else{if(e===null)throw Error(N(310));Ue=e,e={memoizedState:Ue.memoizedState,baseState:Ue.baseState,baseQueue:Ue.baseQueue,queue:Ue.queue,next:null},Ge===null?$e.memoizedState=Ge=e:Ge=Ge.next=e}return Ge}function Ri(e,t){return typeof t=="function"?t(e):t}function Ql(e){var t=jt(),n=t.queue;if(n===null)throw Error(N(311));n.lastRenderedReducer=e;var r=Ue,o=r.baseQueue,i=n.pending;if(i!==null){if(o!==null){var s=o.next;o.next=i.next,i.next=s}r.baseQueue=o=i,n.pending=null}if(o!==null){i=o.next,r=r.baseState;var a=s=null,l=null,c=i;do{var u=c.lane;if((Tr&u)===u)l!==null&&(l=l.next={lane:0,action:c.action,hasEagerState:c.hasEagerState,eagerState:c.eagerState,next:null}),r=c.hasEagerState?c.eagerState:e(r,c.action);else{var d={lane:u,action:c.action,hasEagerState:c.hasEagerState,eagerState:c.eagerState,next:null};l===null?(a=l=d,s=r):l=l.next=d,$e.lanes|=u,Er|=u}c=c.next}while(c!==null&&c!==i);l===null?s=r:l.next=a,qt(r,t.memoizedState)||(ht=!0),t.memoizedState=r,t.baseState=s,t.baseQueue=l,n.lastRenderedState=r}if(e=n.interleaved,e!==null){o=e;do i=o.lane,$e.lanes|=i,Er|=i,o=o.next;while(o!==e)}else o===null&&(n.lanes=0);return[t.memoizedState,n.dispatch]}function Xl(e){var t=jt(),n=t.queue;if(n===null)throw Error(N(311));n.lastRenderedReducer=e;var r=n.dispatch,o=n.pending,i=t.memoizedState;if(o!==null){n.pending=null;var s=o=o.next;do i=e(i,s.action),s=s.next;while(s!==o);qt(i,t.memoizedState)||(ht=!0),t.memoizedState=i,t.baseQueue===null&&(t.baseState=i),n.lastRenderedState=i}return[i,r]}function x1(){}function w1(e,t){var n=$e,r=jt(),o=t(),i=!qt(r.memoizedState,o);if(i&&(r.memoizedState=o,ht=!0),r=r.queue,Gd(S1.bind(null,n,r,e),[e]),r.getSnapshot!==t||i||Ge!==null&&Ge.memoizedState.tag&1){if(n.flags|=2048,$i(9,C1.bind(null,n,r,o,t),void 0,null),Ye===null)throw Error(N(349));(Tr&30)!==0||b1(n,t,o)}return o}function b1(e,t,n){e.flags|=16384,e={getSnapshot:t,value:n},t=$e.updateQueue,t===null?(t={lastEffect:null,stores:null},$e.updateQueue=t,t.stores=[e]):(n=t.stores,n===null?t.stores=[e]:n.push(e))}function C1(e,t,n,r){t.value=n,t.getSnapshot=r,k1(t)&&P1(e)}function S1(e,t,n){return n(function(){k1(t)&&P1(e)})}function k1(e){var t=e.getSnapshot;e=e.value;try{var n=t();return!qt(e,n)}catch{return!0}}function P1(e){var t=bn(e,1);t!==null&&Xt(t,e,1,-1)}function Qh(e){var t=en();return typeof e=="function"&&(e=e()),t.memoizedState=t.baseState=e,e={pending:null,interleaved:null,lanes:0,dispatch:null,lastRenderedReducer:Ri,lastRenderedState:e},t.queue=e,e=e.dispatch=Yx.bind(null,$e,e),[t.memoizedState,e]}function $i(e,t,n,r){return e={tag:e,create:t,destroy:n,deps:r,next:null},t=$e.updateQueue,t===null?(t={lastEffect:null,stores:null},$e.updateQueue=t,t.lastEffect=e.next=e):(n=t.lastEffect,n===null?t.lastEffect=e.next=e:(r=n.next,n.next=e,e.next=r,t.lastEffect=e)),e}function T1(){return jt().memoizedState}function Ns(e,t,n,r){var o=en();$e.flags|=e,o.memoizedState=$i(1|t,n,void 0,r===void 0?null:r)}function Va(e,t,n,r){var o=jt();r=r===void 0?null:r;var i=void 0;if(Ue!==null){var s=Ue.memoizedState;if(i=s.destroy,r!==null&&Ud(r,s.deps)){o.memoizedState=$i(t,n,i,r);return}}$e.flags|=e,o.memoizedState=$i(1|t,n,i,r)}function Xh(e,t){return Ns(8390656,8,e,t)}function Gd(e,t){return Va(2048,8,e,t)}function E1(e,t){return Va(4,2,e,t)}function I1(e,t){return Va(4,4,e,t)}function O1(e,t){if(typeof t=="function")return e=e(),t(e),function(){t(null)};if(t!=null)return e=e(),t.current=e,function(){t.current=null}}function A1(e,t,n){return n=n!=null?n.concat([e]):null,Va(4,4,O1.bind(null,t,e),n)}function Kd(){}function D1(e,t){var n=jt();t=t===void 0?null:t;var r=n.memoizedState;return r!==null&&t!==null&&Ud(t,r[1])?r[0]:(n.memoizedState=[e,t],e)}function M1(e,t){var n=jt();t=t===void 0?null:t;var r=n.memoizedState;return r!==null&&t!==null&&Ud(t,r[1])?r[0]:(e=e(),n.memoizedState=[e,t],e)}function R1(e,t,n){return(Tr&21)===0?(e.baseState&&(e.baseState=!1,ht=!0),e.memoizedState=n):(qt(n,t)||(n=Fg(),$e.lanes|=n,Er|=n,e.baseState=!0),t)}function Gx(e,t){var n=ye;ye=n!==0&&4>n?n:4,e(!0);var r=Yl.transition;Yl.transition={};try{e(!1),t()}finally{ye=n,Yl.transition=r}}function $1(){return jt().memoizedState}function Kx(e,t,n){var r=Wn(e);if(n={lane:r,action:n,hasEagerState:!1,eagerState:null,next:null},L1(e))N1(t,n);else if(n=g1(e,t,n,r),n!==null){var o=ct();Xt(n,e,r,o),_1(n,t,r)}}function Yx(e,t,n){var r=Wn(e),o={lane:r,action:n,hasEagerState:!1,eagerState:null,next:null};if(L1(e))N1(t,o);else{var i=e.alternate;if(e.lanes===0&&(i===null||i.lanes===0)&&(i=t.lastRenderedReducer,i!==null))try{var s=t.lastRenderedState,a=i(s,n);if(o.hasEagerState=!0,o.eagerState=a,qt(a,s)){var l=t.interleaved;l===null?(o.next=o,Fd(t)):(o.next=l.next,l.next=o),t.interleaved=o;return}}catch{}finally{}n=g1(e,t,o,r),n!==null&&(o=ct(),Xt(n,e,r,o),_1(n,t,r))}}function L1(e){var t=e.alternate;return e===$e||t!==null&&t===$e}function N1(e,t){li=da=!0;var n=e.pending;n===null?t.next=t:(t.next=n.next,n.next=t),e.pending=t}function _1(e,t,n){if((n&4194240)!==0){var r=t.lanes;r&=e.pendingLanes,n|=r,t.lanes=n,kd(e,n)}}var fa={readContext:Vt,useCallback:et,useContext:et,useEffect:et,useImperativeHandle:et,useInsertionEffect:et,useLayoutEffect:et,useMemo:et,useReducer:et,useRef:et,useState:et,useDebugValue:et,useDeferredValue:et,useTransition:et,useMutableSource:et,useSyncExternalStore:et,useId:et,unstable_isNewReconciler:!1},Qx={readContext:Vt,useCallback:function(e,t){return en().memoizedState=[e,t===void 0?null:t],e},useContext:Vt,useEffect:Xh,useImperativeHandle:function(e,t,n){return n=n!=null?n.concat([e]):null,Ns(4194308,4,O1.bind(null,t,e),n)},useLayoutEffect:function(e,t){return Ns(4194308,4,e,t)},useInsertionEffect:function(e,t){return Ns(4,2,e,t)},useMemo:function(e,t){var n=en();return t=t===void 0?null:t,e=e(),n.memoizedState=[e,t],e},useReducer:function(e,t,n){var r=en();return t=n!==void 0?n(t):t,r.memoizedState=r.baseState=t,e={pending:null,interleaved:null,lanes:0,dispatch:null,lastRenderedReducer:e,lastRenderedState:t},r.queue=e,e=e.dispatch=Kx.bind(null,$e,e),[r.memoizedState,e]},useRef:function(e){var t=en();return e={current:e},t.memoizedState=e},useState:Qh,useDebugValue:Kd,useDeferredValue:function(e){return en().memoizedState=e},useTransition:function(){var e=Qh(!1),t=e[0];return e=Gx.bind(null,e[1]),en().memoizedState=e,[t,e]},useMutableSource:function(){},useSyncExternalStore:function(e,t,n){var r=$e,o=en();if(Ie){if(n===void 0)throw Error(N(407));n=n()}else{if(n=t(),Ye===null)throw Error(N(349));(Tr&30)!==0||b1(r,t,n)}o.memoizedState=n;var i={value:n,getSnapshot:t};return o.queue=i,Xh(S1.bind(null,r,i,e),[e]),r.flags|=2048,$i(9,C1.bind(null,r,i,n,t),void 0,null),n},useId:function(){var e=en(),t=Ye.identifierPrefix;if(Ie){var n=pn,r=hn;n=(r&~(1<<32-Qt(r)-1)).toString(32)+n,t=":"+t+"R"+n,n=Mi++,0<n&&(t+="H"+n.toString(32)),t+=":"}else n=Wx++,t=":"+t+"r"+n.toString(32)+":";return e.memoizedState=t},unstable_isNewReconciler:!1},Xx={readContext:Vt,useCallback:D1,useContext:Vt,useEffect:Gd,useImperativeHandle:A1,useInsertionEffect:E1,useLayoutEffect:I1,useMemo:M1,useReducer:Ql,useRef:T1,useState:function(){return Ql(Ri)},useDebugValue:Kd,useDeferredValue:function(e){var t=jt();return R1(t,Ue.memoizedState,e)},useTransition:function(){var e=Ql(Ri)[0],t=jt().memoizedState;return[e,t]},useMutableSource:x1,useSyncExternalStore:w1,useId:$1,unstable_isNewReconciler:!1},qx={readContext:Vt,useCallback:D1,useContext:Vt,useEffect:Gd,useImperativeHandle:A1,useInsertionEffect:E1,useLayoutEffect:I1,useMemo:M1,useReducer:Xl,useRef:T1,useState:function(){return Xl(Ri)},useDebugValue:Kd,useDeferredValue:function(e){var t=jt();return Ue===null?t.memoizedState=e:R1(t,Ue.memoizedState,e)},useTransition:function(){var e=Xl(Ri)[0],t=jt().memoizedState;return[e,t]},useMutableSource:x1,useSyncExternalStore:w1,useId:$1,unstable_isNewReconciler:!1};function Wt(e,t){if(e&&e.defaultProps){t=Le({},t),e=e.defaultProps;for(var n in e)t[n]===void 0&&(t[n]=e[n]);return t}return t}function gu(e,t,n,r){t=e.memoizedState,n=n(r,t),n=n==null?t:Le({},t,n),e.memoizedState=n,e.lanes===0&&(e.updateQueue.baseState=n)}var ja={isMounted:function(e){return(e=e._reactInternals)?Rr(e)===e:!1},enqueueSetState:function(e,t,n){e=e._reactInternals;var r=ct(),o=Wn(e),i=gn(r,o);i.payload=t,n!=null&&(i.callback=n),t=Un(e,i,o),t!==null&&(Xt(t,e,o,r),$s(t,e,o))},enqueueReplaceState:function(e,t,n){e=e._reactInternals;var r=ct(),o=Wn(e),i=gn(r,o);i.tag=1,i.payload=t,n!=null&&(i.callback=n),t=Un(e,i,o),t!==null&&(Xt(t,e,o,r),$s(t,e,o))},enqueueForceUpdate:function(e,t){e=e._reactInternals;var n=ct(),r=Wn(e),o=gn(n,r);o.tag=2,t!=null&&(o.callback=t),t=Un(e,o,r),t!==null&&(Xt(t,e,r,n),$s(t,e,r))}};function qh(e,t,n,r,o,i,s){return e=e.stateNode,typeof e.shouldComponentUpdate=="function"?e.shouldComponentUpdate(r,i,s):t.prototype&&t.prototype.isPureReactComponent?!Ti(n,r)||!Ti(o,i):!0}function F1(e,t,n){var r=!1,o=Jn,i=t.contextType;return typeof i=="object"&&i!==null?i=Vt(i):(o=gt(t)?kr:it.current,r=t.contextTypes,i=(r=r!=null)?wo(e,o):Jn),t=new t(n,i),e.memoizedState=t.state!==null&&t.state!==void 0?t.state:null,t.updater=ja,e.stateNode=t,t._reactInternals=e,r&&(e=e.stateNode,e.__reactInternalMemoizedUnmaskedChildContext=o,e.__reactInternalMemoizedMaskedChildContext=i),t}function Zh(e,t,n,r){e=t.state,typeof t.componentWillReceiveProps=="function"&&t.componentWillReceiveProps(n,r),typeof t.UNSAFE_componentWillReceiveProps=="function"&&t.UNSAFE_componentWillReceiveProps(n,r),t.state!==e&&ja.enqueueReplaceState(t,t.state,null)}function yu(e,t,n,r){var o=e.stateNode;o.props=n,o.state=e.memoizedState,o.refs={},zd(e);var i=t.contextType;typeof i=="object"&&i!==null?o.context=Vt(i):(i=gt(t)?kr:it.current,o.context=wo(e,i)),o.state=e.memoizedState,i=t.getDerivedStateFromProps,typeof i=="function"&&(gu(e,t,i,n),o.state=e.memoizedState),typeof t.getDerivedStateFromProps=="function"||typeof o.getSnapshotBeforeUpdate=="function"||typeof o.UNSAFE_componentWillMount!="function"&&typeof o.componentWillMount!="function"||(t=o.state,typeof o.componentWillMount=="function"&&o.componentWillMount(),typeof o.UNSAFE_componentWillMount=="function"&&o.UNSAFE_componentWillMount(),t!==o.state&&ja.enqueueReplaceState(o,o.state,null),ca(e,n,o,r),o.state=e.memoizedState),typeof o.componentDidMount=="function"&&(e.flags|=4194308)}function ko(e,t){try{var n="",r=t;do n+=P2(r),r=r.return;while(r);var o=n}catch(i){o=`
Error generating stack: `+i.message+`
`+i.stack}return{value:e,source:t,stack:o,digest:null}}function ql(e,t,n){return{value:e,source:null,stack:n!=null?n:null,digest:t!=null?t:null}}function vu(e,t){try{console.error(t.value)}catch(n){setTimeout(function(){throw n})}}var Zx=typeof WeakMap=="function"?WeakMap:Map;function z1(e,t,n){n=gn(-1,n),n.tag=3,n.payload={element:null};var r=t.value;return n.callback=function(){pa||(pa=!0,Iu=r),vu(e,t)},n}function V1(e,t,n){n=gn(-1,n),n.tag=3;var r=e.type.getDerivedStateFromError;if(typeof r=="function"){var o=t.value;n.payload=function(){return r(o)},n.callback=function(){vu(e,t)}}var i=e.stateNode;return i!==null&&typeof i.componentDidCatch=="function"&&(n.callback=function(){vu(e,t),typeof r!="function"&&(Hn===null?Hn=new Set([this]):Hn.add(this));var s=t.stack;this.componentDidCatch(t.value,{componentStack:s!==null?s:""})}),n}function Jh(e,t,n){var r=e.pingCache;if(r===null){r=e.pingCache=new Zx;var o=new Set;r.set(t,o)}else o=r.get(t),o===void 0&&(o=new Set,r.set(t,o));o.has(n)||(o.add(n),e=fw.bind(null,e,t,n),t.then(e,e))}function ep(e){do{var t;if((t=e.tag===13)&&(t=e.memoizedState,t=t!==null?t.dehydrated!==null:!0),t)return e;e=e.return}while(e!==null);return null}function tp(e,t,n,r,o){return(e.mode&1)===0?(e===t?e.flags|=65536:(e.flags|=128,n.flags|=131072,n.flags&=-52805,n.tag===1&&(n.alternate===null?n.tag=17:(t=gn(-1,1),t.tag=2,Un(n,t,1))),n.lanes|=1),e):(e.flags|=65536,e.lanes=o,e)}var Jx=Pn.ReactCurrentOwner,ht=!1;function lt(e,t,n,r){t.child=e===null?m1(t,null,n,r):Co(t,e.child,n,r)}function np(e,t,n,r,o){n=n.render;var i=t.ref;return yo(t,o),r=Hd(e,t,n,r,i,o),n=Wd(),e!==null&&!ht?(t.updateQueue=e.updateQueue,t.flags&=-2053,e.lanes&=~o,Cn(e,t,o)):(Ie&&n&&Md(t),t.flags|=1,lt(e,t,r,o),t.child)}function rp(e,t,n,r,o){if(e===null){var i=n.type;return typeof i=="function"&&!tf(i)&&i.defaultProps===void 0&&n.compare===null&&n.defaultProps===void 0?(t.tag=15,t.type=i,j1(e,t,i,r,o)):(e=Vs(n.type,null,r,t,t.mode,o),e.ref=t.ref,e.return=t,t.child=e)}if(i=e.child,(e.lanes&o)===0){var s=i.memoizedProps;if(n=n.compare,n=n!==null?n:Ti,n(s,r)&&e.ref===t.ref)return Cn(e,t,o)}return t.flags|=1,e=Gn(i,r),e.ref=t.ref,e.return=t,t.child=e}function j1(e,t,n,r,o){if(e!==null){var i=e.memoizedProps;if(Ti(i,r)&&e.ref===t.ref)if(ht=!1,t.pendingProps=r=i,(e.lanes&o)!==0)(e.flags&131072)!==0&&(ht=!0);else return t.lanes=e.lanes,Cn(e,t,o)}return xu(e,t,n,r,o)}function B1(e,t,n){var r=t.pendingProps,o=r.children,i=e!==null?e.memoizedState:null;if(r.mode==="hidden")if((t.mode&1)===0)t.memoizedState={baseLanes:0,cachePool:null,transitions:null},Ce(oo,xt),xt|=n;else{if((n&1073741824)===0)return e=i!==null?i.baseLanes|n:n,t.lanes=t.childLanes=1073741824,t.memoizedState={baseLanes:e,cachePool:null,transitions:null},t.updateQueue=null,Ce(oo,xt),xt|=e,null;t.memoizedState={baseLanes:0,cachePool:null,transitions:null},r=i!==null?i.baseLanes:n,Ce(oo,xt),xt|=r}else i!==null?(r=i.baseLanes|n,t.memoizedState=null):r=n,Ce(oo,xt),xt|=r;return lt(e,t,o,n),t.child}function U1(e,t){var n=t.ref;(e===null&&n!==null||e!==null&&e.ref!==n)&&(t.flags|=512,t.flags|=2097152)}function xu(e,t,n,r,o){var i=gt(n)?kr:it.current;return i=wo(t,i),yo(t,o),n=Hd(e,t,n,r,i,o),r=Wd(),e!==null&&!ht?(t.updateQueue=e.updateQueue,t.flags&=-2053,e.lanes&=~o,Cn(e,t,o)):(Ie&&r&&Md(t),t.flags|=1,lt(e,t,n,o),t.child)}function op(e,t,n,r,o){if(gt(n)){var i=!0;oa(t)}else i=!1;if(yo(t,o),t.stateNode===null)_s(e,t),F1(t,n,r),yu(t,n,r,o),r=!0;else if(e===null){var s=t.stateNode,a=t.memoizedProps;s.props=a;var l=s.context,c=n.contextType;typeof c=="object"&&c!==null?c=Vt(c):(c=gt(n)?kr:it.current,c=wo(t,c));var u=n.getDerivedStateFromProps,d=typeof u=="function"||typeof s.getSnapshotBeforeUpdate=="function";d||typeof s.UNSAFE_componentWillReceiveProps!="function"&&typeof s.componentWillReceiveProps!="function"||(a!==r||l!==c)&&Zh(t,s,r,c),On=!1;var p=t.memoizedState;s.state=p,ca(t,r,s,o),l=t.memoizedState,a!==r||p!==l||mt.current||On?(typeof u=="function"&&(gu(t,n,u,r),l=t.memoizedState),(a=On||qh(t,n,a,r,p,l,c))?(d||typeof s.UNSAFE_componentWillMount!="function"&&typeof s.componentWillMount!="function"||(typeof s.componentWillMount=="function"&&s.componentWillMount(),typeof s.UNSAFE_componentWillMount=="function"&&s.UNSAFE_componentWillMount()),typeof s.componentDidMount=="function"&&(t.flags|=4194308)):(typeof s.componentDidMount=="function"&&(t.flags|=4194308),t.memoizedProps=r,t.memoizedState=l),s.props=r,s.state=l,s.context=c,r=a):(typeof s.componentDidMount=="function"&&(t.flags|=4194308),r=!1)}else{s=t.stateNode,y1(e,t),a=t.memoizedProps,c=t.type===t.elementType?a:Wt(t.type,a),s.props=c,d=t.pendingProps,p=s.context,l=n.contextType,typeof l=="object"&&l!==null?l=Vt(l):(l=gt(n)?kr:it.current,l=wo(t,l));var y=n.getDerivedStateFromProps;(u=typeof y=="function"||typeof s.getSnapshotBeforeUpdate=="function")||typeof s.UNSAFE_componentWillReceiveProps!="function"&&typeof s.componentWillReceiveProps!="function"||(a!==d||p!==l)&&Zh(t,s,r,l),On=!1,p=t.memoizedState,s.state=p,ca(t,r,s,o);var w=t.memoizedState;a!==d||p!==w||mt.current||On?(typeof y=="function"&&(gu(t,n,y,r),w=t.memoizedState),(c=On||qh(t,n,c,r,p,w,l)||!1)?(u||typeof s.UNSAFE_componentWillUpdate!="function"&&typeof s.componentWillUpdate!="function"||(typeof s.componentWillUpdate=="function"&&s.componentWillUpdate(r,w,l),typeof s.UNSAFE_componentWillUpdate=="function"&&s.UNSAFE_componentWillUpdate(r,w,l)),typeof s.componentDidUpdate=="function"&&(t.flags|=4),typeof s.getSnapshotBeforeUpdate=="function"&&(t.flags|=1024)):(typeof s.componentDidUpdate!="function"||a===e.memoizedProps&&p===e.memoizedState||(t.flags|=4),typeof s.getSnapshotBeforeUpdate!="function"||a===e.memoizedProps&&p===e.memoizedState||(t.flags|=1024),t.memoizedProps=r,t.memoizedState=w),s.props=r,s.state=w,s.context=l,r=c):(typeof s.componentDidUpdate!="function"||a===e.memoizedProps&&p===e.memoizedState||(t.flags|=4),typeof s.getSnapshotBeforeUpdate!="function"||a===e.memoizedProps&&p===e.memoizedState||(t.flags|=1024),r=!1)}return wu(e,t,n,r,i,o)}function wu(e,t,n,r,o,i){U1(e,t);var s=(t.flags&128)!==0;if(!r&&!s)return o&&Uh(t,n,!1),Cn(e,t,i);r=t.stateNode,Jx.current=t;var a=s&&typeof n.getDerivedStateFromError!="function"?null:r.render();return t.flags|=1,e!==null&&s?(t.child=Co(t,e.child,null,i),t.child=Co(t,null,a,i)):lt(e,t,a,i),t.memoizedState=r.state,o&&Uh(t,n,!0),t.child}function H1(e){var t=e.stateNode;t.pendingContext?Bh(e,t.pendingContext,t.pendingContext!==t.context):t.context&&Bh(e,t.context,!1),Vd(e,t.containerInfo)}function ip(e,t,n,r,o){return bo(),$d(o),t.flags|=256,lt(e,t,n,r),t.child}var bu={dehydrated:null,treeContext:null,retryLane:0};function Cu(e){return{baseLanes:e,cachePool:null,transitions:null}}function W1(e,t,n){var r=t.pendingProps,o=Me.current,i=!1,s=(t.flags&128)!==0,a;if((a=s)||(a=e!==null&&e.memoizedState===null?!1:(o&2)!==0),a?(i=!0,t.flags&=-129):(e===null||e.memoizedState!==null)&&(o|=1),Ce(Me,o&1),e===null)return pu(t),e=t.memoizedState,e!==null&&(e=e.dehydrated,e!==null)?((t.mode&1)===0?t.lanes=1:e.data==="$!"?t.lanes=8:t.lanes=1073741824,null):(s=r.children,e=r.fallback,i?(r=t.mode,i=t.child,s={mode:"hidden",children:s},(r&1)===0&&i!==null?(i.childLanes=0,i.pendingProps=s):i=Ha(s,r,0,null),e=Cr(e,r,n,null),i.return=t,e.return=t,i.sibling=e,t.child=i,t.child.memoizedState=Cu(n),t.memoizedState=bu,e):Yd(t,s));if(o=e.memoizedState,o!==null&&(a=o.dehydrated,a!==null))return ew(e,t,s,r,a,o,n);if(i){i=r.fallback,s=t.mode,o=e.child,a=o.sibling;var l={mode:"hidden",children:r.children};return(s&1)===0&&t.child!==o?(r=t.child,r.childLanes=0,r.pendingProps=l,t.deletions=null):(r=Gn(o,l),r.subtreeFlags=o.subtreeFlags&14680064),a!==null?i=Gn(a,i):(i=Cr(i,s,n,null),i.flags|=2),i.return=t,r.return=t,r.sibling=i,t.child=r,r=i,i=t.child,s=e.child.memoizedState,s=s===null?Cu(n):{baseLanes:s.baseLanes|n,cachePool:null,transitions:s.transitions},i.memoizedState=s,i.childLanes=e.childLanes&~n,t.memoizedState=bu,r}return i=e.child,e=i.sibling,r=Gn(i,{mode:"visible",children:r.children}),(t.mode&1)===0&&(r.lanes=n),r.return=t,r.sibling=null,e!==null&&(n=t.deletions,n===null?(t.deletions=[e],t.flags|=16):n.push(e)),t.child=r,t.memoizedState=null,r}function Yd(e,t){return t=Ha({mode:"visible",children:t},e.mode,0,null),t.return=e,e.child=t}function ms(e,t,n,r){return r!==null&&$d(r),Co(t,e.child,null,n),e=Yd(t,t.pendingProps.children),e.flags|=2,t.memoizedState=null,e}function ew(e,t,n,r,o,i,s){if(n)return t.flags&256?(t.flags&=-257,r=ql(Error(N(422))),ms(e,t,s,r)):t.memoizedState!==null?(t.child=e.child,t.flags|=128,null):(i=r.fallback,o=t.mode,r=Ha({mode:"visible",children:r.children},o,0,null),i=Cr(i,o,s,null),i.flags|=2,r.return=t,i.return=t,r.sibling=i,t.child=r,(t.mode&1)!==0&&Co(t,e.child,null,s),t.child.memoizedState=Cu(s),t.memoizedState=bu,i);if((t.mode&1)===0)return ms(e,t,s,null);if(o.data==="$!"){if(r=o.nextSibling&&o.nextSibling.dataset,r)var a=r.dgst;return r=a,i=Error(N(419)),r=ql(i,r,void 0),ms(e,t,s,r)}if(a=(s&e.childLanes)!==0,ht||a){if(r=Ye,r!==null){switch(s&-s){case 4:o=2;break;case 16:o=8;break;case 64:case 128:case 256:case 512:case 1024:case 2048:case 4096:case 8192:case 16384:case 32768:case 65536:case 131072:case 262144:case 524288:case 1048576:case 2097152:case 4194304:case 8388608:case 16777216:case 33554432:case 67108864:o=32;break;case 536870912:o=268435456;break;default:o=0}o=(o&(r.suspendedLanes|s))!==0?0:o,o!==0&&o!==i.retryLane&&(i.retryLane=o,bn(e,o),Xt(r,e,o,-1))}return ef(),r=ql(Error(N(421))),ms(e,t,s,r)}return o.data==="$?"?(t.flags|=128,t.child=e.child,t=hw.bind(null,e),o._reactRetry=t,null):(e=i.treeContext,wt=Bn(o.nextSibling),bt=t,Ie=!0,Kt=null,e!==null&&($t[Lt++]=hn,$t[Lt++]=pn,$t[Lt++]=Pr,hn=e.id,pn=e.overflow,Pr=t),t=Yd(t,r.children),t.flags|=4096,t)}function sp(e,t,n){e.lanes|=t;var r=e.alternate;r!==null&&(r.lanes|=t),mu(e.return,t,n)}function Zl(e,t,n,r,o){var i=e.memoizedState;i===null?e.memoizedState={isBackwards:t,rendering:null,renderingStartTime:0,last:r,tail:n,tailMode:o}:(i.isBackwards=t,i.rendering=null,i.renderingStartTime=0,i.last=r,i.tail=n,i.tailMode=o)}function G1(e,t,n){var r=t.pendingProps,o=r.revealOrder,i=r.tail;if(lt(e,t,r.children,n),r=Me.current,(r&2)!==0)r=r&1|2,t.flags|=128;else{if(e!==null&&(e.flags&128)!==0)e:for(e=t.child;e!==null;){if(e.tag===13)e.memoizedState!==null&&sp(e,n,t);else if(e.tag===19)sp(e,n,t);else if(e.child!==null){e.child.return=e,e=e.child;continue}if(e===t)break e;for(;e.sibling===null;){if(e.return===null||e.return===t)break e;e=e.return}e.sibling.return=e.return,e=e.sibling}r&=1}if(Ce(Me,r),(t.mode&1)===0)t.memoizedState=null;else switch(o){case"forwards":for(n=t.child,o=null;n!==null;)e=n.alternate,e!==null&&ua(e)===null&&(o=n),n=n.sibling;n=o,n===null?(o=t.child,t.child=null):(o=n.sibling,n.sibling=null),Zl(t,!1,o,n,i);break;case"backwards":for(n=null,o=t.child,t.child=null;o!==null;){if(e=o.alternate,e!==null&&ua(e)===null){t.child=o;break}e=o.sibling,o.sibling=n,n=o,o=e}Zl(t,!0,n,null,i);break;case"together":Zl(t,!1,null,null,void 0);break;default:t.memoizedState=null}return t.child}function _s(e,t){(t.mode&1)===0&&e!==null&&(e.alternate=null,t.alternate=null,t.flags|=2)}function Cn(e,t,n){if(e!==null&&(t.dependencies=e.dependencies),Er|=t.lanes,(n&t.childLanes)===0)return null;if(e!==null&&t.child!==e.child)throw Error(N(153));if(t.child!==null){for(e=t.child,n=Gn(e,e.pendingProps),t.child=n,n.return=t;e.sibling!==null;)e=e.sibling,n=n.sibling=Gn(e,e.pendingProps),n.return=t;n.sibling=null}return t.child}function tw(e,t,n){switch(t.tag){case 3:H1(t),bo();break;case 5:v1(t);break;case 1:gt(t.type)&&oa(t);break;case 4:Vd(t,t.stateNode.containerInfo);break;case 10:var r=t.type._context,o=t.memoizedProps.value;Ce(aa,r._currentValue),r._currentValue=o;break;case 13:if(r=t.memoizedState,r!==null)return r.dehydrated!==null?(Ce(Me,Me.current&1),t.flags|=128,null):(n&t.child.childLanes)!==0?W1(e,t,n):(Ce(Me,Me.current&1),e=Cn(e,t,n),e!==null?e.sibling:null);Ce(Me,Me.current&1);break;case 19:if(r=(n&t.childLanes)!==0,(e.flags&128)!==0){if(r)return G1(e,t,n);t.flags|=128}if(o=t.memoizedState,o!==null&&(o.rendering=null,o.tail=null,o.lastEffect=null),Ce(Me,Me.current),r)break;return null;case 22:case 23:return t.lanes=0,B1(e,t,n)}return Cn(e,t,n)}var K1,Su,Y1,Q1;K1=function(e,t){for(var n=t.child;n!==null;){if(n.tag===5||n.tag===6)e.appendChild(n.stateNode);else if(n.tag!==4&&n.child!==null){n.child.return=n,n=n.child;continue}if(n===t)break;for(;n.sibling===null;){if(n.return===null||n.return===t)return;n=n.return}n.sibling.return=n.return,n=n.sibling}};Su=function(){};Y1=function(e,t,n,r){var o=e.memoizedProps;if(o!==r){e=t.stateNode,xr(sn.current);var i=null;switch(n){case"input":o=Wc(e,o),r=Wc(e,r),i=[];break;case"select":o=Le({},o,{value:void 0}),r=Le({},r,{value:void 0}),i=[];break;case"textarea":o=Yc(e,o),r=Yc(e,r),i=[];break;default:typeof o.onClick!="function"&&typeof r.onClick=="function"&&(e.onclick=na)}Xc(n,r);var s;n=null;for(c in o)if(!r.hasOwnProperty(c)&&o.hasOwnProperty(c)&&o[c]!=null)if(c==="style"){var a=o[c];for(s in a)a.hasOwnProperty(s)&&(n||(n={}),n[s]="")}else c!=="dangerouslySetInnerHTML"&&c!=="children"&&c!=="suppressContentEditableWarning"&&c!=="suppressHydrationWarning"&&c!=="autoFocus"&&(xi.hasOwnProperty(c)?i||(i=[]):(i=i||[]).push(c,null));for(c in r){var l=r[c];if(a=o!=null?o[c]:void 0,r.hasOwnProperty(c)&&l!==a&&(l!=null||a!=null))if(c==="style")if(a){for(s in a)!a.hasOwnProperty(s)||l&&l.hasOwnProperty(s)||(n||(n={}),n[s]="");for(s in l)l.hasOwnProperty(s)&&a[s]!==l[s]&&(n||(n={}),n[s]=l[s])}else n||(i||(i=[]),i.push(c,n)),n=l;else c==="dangerouslySetInnerHTML"?(l=l?l.__html:void 0,a=a?a.__html:void 0,l!=null&&a!==l&&(i=i||[]).push(c,l)):c==="children"?typeof l!="string"&&typeof l!="number"||(i=i||[]).push(c,""+l):c!=="suppressContentEditableWarning"&&c!=="suppressHydrationWarning"&&(xi.hasOwnProperty(c)?(l!=null&&c==="onScroll"&&ke("scroll",e),i||a===l||(i=[])):(i=i||[]).push(c,l))}n&&(i=i||[]).push("style",n);var c=i;(t.updateQueue=c)&&(t.flags|=4)}};Q1=function(e,t,n,r){n!==r&&(t.flags|=4)};function jo(e,t){if(!Ie)switch(e.tailMode){case"hidden":t=e.tail;for(var n=null;t!==null;)t.alternate!==null&&(n=t),t=t.sibling;n===null?e.tail=null:n.sibling=null;break;case"collapsed":n=e.tail;for(var r=null;n!==null;)n.alternate!==null&&(r=n),n=n.sibling;r===null?t||e.tail===null?e.tail=null:e.tail.sibling=null:r.sibling=null}}function tt(e){var t=e.alternate!==null&&e.alternate.child===e.child,n=0,r=0;if(t)for(var o=e.child;o!==null;)n|=o.lanes|o.childLanes,r|=o.subtreeFlags&14680064,r|=o.flags&14680064,o.return=e,o=o.sibling;else for(o=e.child;o!==null;)n|=o.lanes|o.childLanes,r|=o.subtreeFlags,r|=o.flags,o.return=e,o=o.sibling;return e.subtreeFlags|=r,e.childLanes=n,t}function nw(e,t,n){var r=t.pendingProps;switch(Rd(t),t.tag){case 2:case 16:case 15:case 0:case 11:case 7:case 8:case 12:case 9:case 14:return tt(t),null;case 1:return gt(t.type)&&ra(),tt(t),null;case 3:return r=t.stateNode,So(),Pe(mt),Pe(it),Bd(),r.pendingContext&&(r.context=r.pendingContext,r.pendingContext=null),(e===null||e.child===null)&&(hs(t)?t.flags|=4:e===null||e.memoizedState.isDehydrated&&(t.flags&256)===0||(t.flags|=1024,Kt!==null&&(Du(Kt),Kt=null))),Su(e,t),tt(t),null;case 5:jd(t);var o=xr(Di.current);if(n=t.type,e!==null&&t.stateNode!=null)Y1(e,t,n,r,o),e.ref!==t.ref&&(t.flags|=512,t.flags|=2097152);else{if(!r){if(t.stateNode===null)throw Error(N(166));return tt(t),null}if(e=xr(sn.current),hs(t)){r=t.stateNode,n=t.type;var i=t.memoizedProps;switch(r[tn]=t,r[Oi]=i,e=(t.mode&1)!==0,n){case"dialog":ke("cancel",r),ke("close",r);break;case"iframe":case"object":case"embed":ke("load",r);break;case"video":case"audio":for(o=0;o<ei.length;o++)ke(ei[o],r);break;case"source":ke("error",r);break;case"img":case"image":case"link":ke("error",r),ke("load",r);break;case"details":ke("toggle",r);break;case"input":mh(r,i),ke("invalid",r);break;case"select":r._wrapperState={wasMultiple:!!i.multiple},ke("invalid",r);break;case"textarea":yh(r,i),ke("invalid",r)}Xc(n,i),o=null;for(var s in i)if(i.hasOwnProperty(s)){var a=i[s];s==="children"?typeof a=="string"?r.textContent!==a&&(i.suppressHydrationWarning!==!0&&fs(r.textContent,a,e),o=["children",a]):typeof a=="number"&&r.textContent!==""+a&&(i.suppressHydrationWarning!==!0&&fs(r.textContent,a,e),o=["children",""+a]):xi.hasOwnProperty(s)&&a!=null&&s==="onScroll"&&ke("scroll",r)}switch(n){case"input":os(r),gh(r,i,!0);break;case"textarea":os(r),vh(r);break;case"select":case"option":break;default:typeof i.onClick=="function"&&(r.onclick=na)}r=o,t.updateQueue=r,r!==null&&(t.flags|=4)}else{s=o.nodeType===9?o:o.ownerDocument,e==="http://www.w3.org/1999/xhtml"&&(e=Sg(n)),e==="http://www.w3.org/1999/xhtml"?n==="script"?(e=s.createElement("div"),e.innerHTML="<script><\/script>",e=e.removeChild(e.firstChild)):typeof r.is=="string"?e=s.createElement(n,{is:r.is}):(e=s.createElement(n),n==="select"&&(s=e,r.multiple?s.multiple=!0:r.size&&(s.size=r.size))):e=s.createElementNS(e,n),e[tn]=t,e[Oi]=r,K1(e,t,!1,!1),t.stateNode=e;e:{switch(s=qc(n,r),n){case"dialog":ke("cancel",e),ke("close",e),o=r;break;case"iframe":case"object":case"embed":ke("load",e),o=r;break;case"video":case"audio":for(o=0;o<ei.length;o++)ke(ei[o],e);o=r;break;case"source":ke("error",e),o=r;break;case"img":case"image":case"link":ke("error",e),ke("load",e),o=r;break;case"details":ke("toggle",e),o=r;break;case"input":mh(e,r),o=Wc(e,r),ke("invalid",e);break;case"option":o=r;break;case"select":e._wrapperState={wasMultiple:!!r.multiple},o=Le({},r,{value:void 0}),ke("invalid",e);break;case"textarea":yh(e,r),o=Yc(e,r),ke("invalid",e);break;default:o=r}Xc(n,o),a=o;for(i in a)if(a.hasOwnProperty(i)){var l=a[i];i==="style"?Tg(e,l):i==="dangerouslySetInnerHTML"?(l=l?l.__html:void 0,l!=null&&kg(e,l)):i==="children"?typeof l=="string"?(n!=="textarea"||l!=="")&&wi(e,l):typeof l=="number"&&wi(e,""+l):i!=="suppressContentEditableWarning"&&i!=="suppressHydrationWarning"&&i!=="autoFocus"&&(xi.hasOwnProperty(i)?l!=null&&i==="onScroll"&&ke("scroll",e):l!=null&&vd(e,i,l,s))}switch(n){case"input":os(e),gh(e,r,!1);break;case"textarea":os(e),vh(e);break;case"option":r.value!=null&&e.setAttribute("value",""+Zn(r.value));break;case"select":e.multiple=!!r.multiple,i=r.value,i!=null?ho(e,!!r.multiple,i,!1):r.defaultValue!=null&&ho(e,!!r.multiple,r.defaultValue,!0);break;default:typeof o.onClick=="function"&&(e.onclick=na)}switch(n){case"button":case"input":case"select":case"textarea":r=!!r.autoFocus;break e;case"img":r=!0;break e;default:r=!1}}r&&(t.flags|=4)}t.ref!==null&&(t.flags|=512,t.flags|=2097152)}return tt(t),null;case 6:if(e&&t.stateNode!=null)Q1(e,t,e.memoizedProps,r);else{if(typeof r!="string"&&t.stateNode===null)throw Error(N(166));if(n=xr(Di.current),xr(sn.current),hs(t)){if(r=t.stateNode,n=t.memoizedProps,r[tn]=t,(i=r.nodeValue!==n)&&(e=bt,e!==null))switch(e.tag){case 3:fs(r.nodeValue,n,(e.mode&1)!==0);break;case 5:e.memoizedProps.suppressHydrationWarning!==!0&&fs(r.nodeValue,n,(e.mode&1)!==0)}i&&(t.flags|=4)}else r=(n.nodeType===9?n:n.ownerDocument).createTextNode(r),r[tn]=t,t.stateNode=r}return tt(t),null;case 13:if(Pe(Me),r=t.memoizedState,e===null||e.memoizedState!==null&&e.memoizedState.dehydrated!==null){if(Ie&&wt!==null&&(t.mode&1)!==0&&(t.flags&128)===0)h1(),bo(),t.flags|=98560,i=!1;else if(i=hs(t),r!==null&&r.dehydrated!==null){if(e===null){if(!i)throw Error(N(318));if(i=t.memoizedState,i=i!==null?i.dehydrated:null,!i)throw Error(N(317));i[tn]=t}else bo(),(t.flags&128)===0&&(t.memoizedState=null),t.flags|=4;tt(t),i=!1}else Kt!==null&&(Du(Kt),Kt=null),i=!0;if(!i)return t.flags&65536?t:null}return(t.flags&128)!==0?(t.lanes=n,t):(r=r!==null,r!==(e!==null&&e.memoizedState!==null)&&r&&(t.child.flags|=8192,(t.mode&1)!==0&&(e===null||(Me.current&1)!==0?We===0&&(We=3):ef())),t.updateQueue!==null&&(t.flags|=4),tt(t),null);case 4:return So(),Su(e,t),e===null&&Ei(t.stateNode.containerInfo),tt(t),null;case 10:return _d(t.type._context),tt(t),null;case 17:return gt(t.type)&&ra(),tt(t),null;case 19:if(Pe(Me),i=t.memoizedState,i===null)return tt(t),null;if(r=(t.flags&128)!==0,s=i.rendering,s===null)if(r)jo(i,!1);else{if(We!==0||e!==null&&(e.flags&128)!==0)for(e=t.child;e!==null;){if(s=ua(e),s!==null){for(t.flags|=128,jo(i,!1),r=s.updateQueue,r!==null&&(t.updateQueue=r,t.flags|=4),t.subtreeFlags=0,r=n,n=t.child;n!==null;)i=n,e=r,i.flags&=14680066,s=i.alternate,s===null?(i.childLanes=0,i.lanes=e,i.child=null,i.subtreeFlags=0,i.memoizedProps=null,i.memoizedState=null,i.updateQueue=null,i.dependencies=null,i.stateNode=null):(i.childLanes=s.childLanes,i.lanes=s.lanes,i.child=s.child,i.subtreeFlags=0,i.deletions=null,i.memoizedProps=s.memoizedProps,i.memoizedState=s.memoizedState,i.updateQueue=s.updateQueue,i.type=s.type,e=s.dependencies,i.dependencies=e===null?null:{lanes:e.lanes,firstContext:e.firstContext}),n=n.sibling;return Ce(Me,Me.current&1|2),t.child}e=e.sibling}i.tail!==null&&ze()>Po&&(t.flags|=128,r=!0,jo(i,!1),t.lanes=4194304)}else{if(!r)if(e=ua(s),e!==null){if(t.flags|=128,r=!0,n=e.updateQueue,n!==null&&(t.updateQueue=n,t.flags|=4),jo(i,!0),i.tail===null&&i.tailMode==="hidden"&&!s.alternate&&!Ie)return tt(t),null}else 2*ze()-i.renderingStartTime>Po&&n!==1073741824&&(t.flags|=128,r=!0,jo(i,!1),t.lanes=4194304);i.isBackwards?(s.sibling=t.child,t.child=s):(n=i.last,n!==null?n.sibling=s:t.child=s,i.last=s)}return i.tail!==null?(t=i.tail,i.rendering=t,i.tail=t.sibling,i.renderingStartTime=ze(),t.sibling=null,n=Me.current,Ce(Me,r?n&1|2:n&1),t):(tt(t),null);case 22:case 23:return Jd(),r=t.memoizedState!==null,e!==null&&e.memoizedState!==null!==r&&(t.flags|=8192),r&&(t.mode&1)!==0?(xt&1073741824)!==0&&(tt(t),t.subtreeFlags&6&&(t.flags|=8192)):tt(t),null;case 24:return null;case 25:return null}throw Error(N(156,t.tag))}function rw(e,t){switch(Rd(t),t.tag){case 1:return gt(t.type)&&ra(),e=t.flags,e&65536?(t.flags=e&-65537|128,t):null;case 3:return So(),Pe(mt),Pe(it),Bd(),e=t.flags,(e&65536)!==0&&(e&128)===0?(t.flags=e&-65537|128,t):null;case 5:return jd(t),null;case 13:if(Pe(Me),e=t.memoizedState,e!==null&&e.dehydrated!==null){if(t.alternate===null)throw Error(N(340));bo()}return e=t.flags,e&65536?(t.flags=e&-65537|128,t):null;case 19:return Pe(Me),null;case 4:return So(),null;case 10:return _d(t.type._context),null;case 22:case 23:return Jd(),null;case 24:return null;default:return null}}var gs=!1,rt=!1,ow=typeof WeakSet=="function"?WeakSet:Set,K=null;function ro(e,t){var n=e.ref;if(n!==null)if(typeof n=="function")try{n(null)}catch(r){Ne(e,t,r)}else n.current=null}function ku(e,t,n){try{n()}catch(r){Ne(e,t,r)}}var ap=!1;function iw(e,t){if(au=Js,e=e1(),Dd(e)){if("selectionStart"in e)var n={start:e.selectionStart,end:e.selectionEnd};else e:{n=(n=e.ownerDocument)&&n.defaultView||window;var r=n.getSelection&&n.getSelection();if(r&&r.rangeCount!==0){n=r.anchorNode;var o=r.anchorOffset,i=r.focusNode;r=r.focusOffset;try{n.nodeType,i.nodeType}catch{n=null;break e}var s=0,a=-1,l=-1,c=0,u=0,d=e,p=null;t:for(;;){for(var y;d!==n||o!==0&&d.nodeType!==3||(a=s+o),d!==i||r!==0&&d.nodeType!==3||(l=s+r),d.nodeType===3&&(s+=d.nodeValue.length),(y=d.firstChild)!==null;)p=d,d=y;for(;;){if(d===e)break t;if(p===n&&++c===o&&(a=s),p===i&&++u===r&&(l=s),(y=d.nextSibling)!==null)break;d=p,p=d.parentNode}d=y}n=a===-1||l===-1?null:{start:a,end:l}}else n=null}n=n||{start:0,end:0}}else n=null;for(lu={focusedElem:e,selectionRange:n},Js=!1,K=t;K!==null;)if(t=K,e=t.child,(t.subtreeFlags&1028)!==0&&e!==null)e.return=t,K=e;else for(;K!==null;){t=K;try{var w=t.alternate;if((t.flags&1024)!==0)switch(t.tag){case 0:case 11:case 15:break;case 1:if(w!==null){var x=w.memoizedProps,b=w.memoizedState,g=t.stateNode,h=g.getSnapshotBeforeUpdate(t.elementType===t.type?x:Wt(t.type,x),b);g.__reactInternalSnapshotBeforeUpdate=h}break;case 3:var m=t.stateNode.containerInfo;m.nodeType===1?m.textContent="":m.nodeType===9&&m.documentElement&&m.removeChild(m.documentElement);break;case 5:case 6:case 4:case 17:break;default:throw Error(N(163))}}catch(S){Ne(t,t.return,S)}if(e=t.sibling,e!==null){e.return=t.return,K=e;break}K=t.return}return w=ap,ap=!1,w}function ci(e,t,n){var r=t.updateQueue;if(r=r!==null?r.lastEffect:null,r!==null){var o=r=r.next;do{if((o.tag&e)===e){var i=o.destroy;o.destroy=void 0,i!==void 0&&ku(t,n,i)}o=o.next}while(o!==r)}}function Ba(e,t){if(t=t.updateQueue,t=t!==null?t.lastEffect:null,t!==null){var n=t=t.next;do{if((n.tag&e)===e){var r=n.create;n.destroy=r()}n=n.next}while(n!==t)}}function Pu(e){var t=e.ref;if(t!==null){var n=e.stateNode;switch(e.tag){case 5:e=n;break;default:e=n}typeof t=="function"?t(e):t.current=e}}function X1(e){var t=e.alternate;t!==null&&(e.alternate=null,X1(t)),e.child=null,e.deletions=null,e.sibling=null,e.tag===5&&(t=e.stateNode,t!==null&&(delete t[tn],delete t[Oi],delete t[du],delete t[jx],delete t[Bx])),e.stateNode=null,e.return=null,e.dependencies=null,e.memoizedProps=null,e.memoizedState=null,e.pendingProps=null,e.stateNode=null,e.updateQueue=null}function q1(e){return e.tag===5||e.tag===3||e.tag===4}function lp(e){e:for(;;){for(;e.sibling===null;){if(e.return===null||q1(e.return))return null;e=e.return}for(e.sibling.return=e.return,e=e.sibling;e.tag!==5&&e.tag!==6&&e.tag!==18;){if(e.flags&2||e.child===null||e.tag===4)continue e;e.child.return=e,e=e.child}if(!(e.flags&2))return e.stateNode}}function Tu(e,t,n){var r=e.tag;if(r===5||r===6)e=e.stateNode,t?n.nodeType===8?n.parentNode.insertBefore(e,t):n.insertBefore(e,t):(n.nodeType===8?(t=n.parentNode,t.insertBefore(e,n)):(t=n,t.appendChild(e)),n=n._reactRootContainer,n!=null||t.onclick!==null||(t.onclick=na));else if(r!==4&&(e=e.child,e!==null))for(Tu(e,t,n),e=e.sibling;e!==null;)Tu(e,t,n),e=e.sibling}function Eu(e,t,n){var r=e.tag;if(r===5||r===6)e=e.stateNode,t?n.insertBefore(e,t):n.appendChild(e);else if(r!==4&&(e=e.child,e!==null))for(Eu(e,t,n),e=e.sibling;e!==null;)Eu(e,t,n),e=e.sibling}var qe=null,Gt=!1;function Tn(e,t,n){for(n=n.child;n!==null;)Z1(e,t,n),n=n.sibling}function Z1(e,t,n){if(on&&typeof on.onCommitFiberUnmount=="function")try{on.onCommitFiberUnmount($a,n)}catch{}switch(n.tag){case 5:rt||ro(n,t);case 6:var r=qe,o=Gt;qe=null,Tn(e,t,n),qe=r,Gt=o,qe!==null&&(Gt?(e=qe,n=n.stateNode,e.nodeType===8?e.parentNode.removeChild(n):e.removeChild(n)):qe.removeChild(n.stateNode));break;case 18:qe!==null&&(Gt?(e=qe,n=n.stateNode,e.nodeType===8?Wl(e.parentNode,n):e.nodeType===1&&Wl(e,n),ki(e)):Wl(qe,n.stateNode));break;case 4:r=qe,o=Gt,qe=n.stateNode.containerInfo,Gt=!0,Tn(e,t,n),qe=r,Gt=o;break;case 0:case 11:case 14:case 15:if(!rt&&(r=n.updateQueue,r!==null&&(r=r.lastEffect,r!==null))){o=r=r.next;do{var i=o,s=i.destroy;i=i.tag,s!==void 0&&((i&2)!==0||(i&4)!==0)&&ku(n,t,s),o=o.next}while(o!==r)}Tn(e,t,n);break;case 1:if(!rt&&(ro(n,t),r=n.stateNode,typeof r.componentWillUnmount=="function"))try{r.props=n.memoizedProps,r.state=n.memoizedState,r.componentWillUnmount()}catch(a){Ne(n,t,a)}Tn(e,t,n);break;case 21:Tn(e,t,n);break;case 22:n.mode&1?(rt=(r=rt)||n.memoizedState!==null,Tn(e,t,n),rt=r):Tn(e,t,n);break;default:Tn(e,t,n)}}function cp(e){var t=e.updateQueue;if(t!==null){e.updateQueue=null;var n=e.stateNode;n===null&&(n=e.stateNode=new ow),t.forEach(function(r){var o=pw.bind(null,e,r);n.has(r)||(n.add(r),r.then(o,o))})}}function Ut(e,t){var n=t.deletions;if(n!==null)for(var r=0;r<n.length;r++){var o=n[r];try{var i=e,s=t,a=s;e:for(;a!==null;){switch(a.tag){case 5:qe=a.stateNode,Gt=!1;break e;case 3:qe=a.stateNode.containerInfo,Gt=!0;break e;case 4:qe=a.stateNode.containerInfo,Gt=!0;break e}a=a.return}if(qe===null)throw Error(N(160));Z1(i,s,o),qe=null,Gt=!1;var l=o.alternate;l!==null&&(l.return=null),o.return=null}catch(c){Ne(o,t,c)}}if(t.subtreeFlags&12854)for(t=t.child;t!==null;)J1(t,e),t=t.sibling}function J1(e,t){var n=e.alternate,r=e.flags;switch(e.tag){case 0:case 11:case 14:case 15:if(Ut(t,e),Jt(e),r&4){try{ci(3,e,e.return),Ba(3,e)}catch(x){Ne(e,e.return,x)}try{ci(5,e,e.return)}catch(x){Ne(e,e.return,x)}}break;case 1:Ut(t,e),Jt(e),r&512&&n!==null&&ro(n,n.return);break;case 5:if(Ut(t,e),Jt(e),r&512&&n!==null&&ro(n,n.return),e.flags&32){var o=e.stateNode;try{wi(o,"")}catch(x){Ne(e,e.return,x)}}if(r&4&&(o=e.stateNode,o!=null)){var i=e.memoizedProps,s=n!==null?n.memoizedProps:i,a=e.type,l=e.updateQueue;if(e.updateQueue=null,l!==null)try{a==="input"&&i.type==="radio"&&i.name!=null&&bg(o,i),qc(a,s);var c=qc(a,i);for(s=0;s<l.length;s+=2){var u=l[s],d=l[s+1];u==="style"?Tg(o,d):u==="dangerouslySetInnerHTML"?kg(o,d):u==="children"?wi(o,d):vd(o,u,d,c)}switch(a){case"input":Gc(o,i);break;case"textarea":Cg(o,i);break;case"select":var p=o._wrapperState.wasMultiple;o._wrapperState.wasMultiple=!!i.multiple;var y=i.value;y!=null?ho(o,!!i.multiple,y,!1):p!==!!i.multiple&&(i.defaultValue!=null?ho(o,!!i.multiple,i.defaultValue,!0):ho(o,!!i.multiple,i.multiple?[]:"",!1))}o[Oi]=i}catch(x){Ne(e,e.return,x)}}break;case 6:if(Ut(t,e),Jt(e),r&4){if(e.stateNode===null)throw Error(N(162));o=e.stateNode,i=e.memoizedProps;try{o.nodeValue=i}catch(x){Ne(e,e.return,x)}}break;case 3:if(Ut(t,e),Jt(e),r&4&&n!==null&&n.memoizedState.isDehydrated)try{ki(t.containerInfo)}catch(x){Ne(e,e.return,x)}break;case 4:Ut(t,e),Jt(e);break;case 13:Ut(t,e),Jt(e),o=e.child,o.flags&8192&&(i=o.memoizedState!==null,o.stateNode.isHidden=i,!i||o.alternate!==null&&o.alternate.memoizedState!==null||(qd=ze())),r&4&&cp(e);break;case 22:if(u=n!==null&&n.memoizedState!==null,e.mode&1?(rt=(c=rt)||u,Ut(t,e),rt=c):Ut(t,e),Jt(e),r&8192){if(c=e.memoizedState!==null,(e.stateNode.isHidden=c)&&!u&&(e.mode&1)!==0)for(K=e,u=e.child;u!==null;){for(d=K=u;K!==null;){switch(p=K,y=p.child,p.tag){case 0:case 11:case 14:case 15:ci(4,p,p.return);break;case 1:ro(p,p.return);var w=p.stateNode;if(typeof w.componentWillUnmount=="function"){r=p,n=p.return;try{t=r,w.props=t.memoizedProps,w.state=t.memoizedState,w.componentWillUnmount()}catch(x){Ne(r,n,x)}}break;case 5:ro(p,p.return);break;case 22:if(p.memoizedState!==null){dp(d);continue}}y!==null?(y.return=p,K=y):dp(d)}u=u.sibling}e:for(u=null,d=e;;){if(d.tag===5){if(u===null){u=d;try{o=d.stateNode,c?(i=o.style,typeof i.setProperty=="function"?i.setProperty("display","none","important"):i.display="none"):(a=d.stateNode,l=d.memoizedProps.style,s=l!=null&&l.hasOwnProperty("display")?l.display:null,a.style.display=Pg("display",s))}catch(x){Ne(e,e.return,x)}}}else if(d.tag===6){if(u===null)try{d.stateNode.nodeValue=c?"":d.memoizedProps}catch(x){Ne(e,e.return,x)}}else if((d.tag!==22&&d.tag!==23||d.memoizedState===null||d===e)&&d.child!==null){d.child.return=d,d=d.child;continue}if(d===e)break e;for(;d.sibling===null;){if(d.return===null||d.return===e)break e;u===d&&(u=null),d=d.return}u===d&&(u=null),d.sibling.return=d.return,d=d.sibling}}break;case 19:Ut(t,e),Jt(e),r&4&&cp(e);break;case 21:break;default:Ut(t,e),Jt(e)}}function Jt(e){var t=e.flags;if(t&2){try{e:{for(var n=e.return;n!==null;){if(q1(n)){var r=n;break e}n=n.return}throw Error(N(160))}switch(r.tag){case 5:var o=r.stateNode;r.flags&32&&(wi(o,""),r.flags&=-33);var i=lp(e);Eu(e,i,o);break;case 3:case 4:var s=r.stateNode.containerInfo,a=lp(e);Tu(e,a,s);break;default:throw Error(N(161))}}catch(l){Ne(e,e.return,l)}e.flags&=-3}t&4096&&(e.flags&=-4097)}function sw(e,t,n){K=e,ey(e)}function ey(e,t,n){for(var r=(e.mode&1)!==0;K!==null;){var o=K,i=o.child;if(o.tag===22&&r){var s=o.memoizedState!==null||gs;if(!s){var a=o.alternate,l=a!==null&&a.memoizedState!==null||rt;a=gs;var c=rt;if(gs=s,(rt=l)&&!c)for(K=o;K!==null;)s=K,l=s.child,s.tag===22&&s.memoizedState!==null?fp(o):l!==null?(l.return=s,K=l):fp(o);for(;i!==null;)K=i,ey(i),i=i.sibling;K=o,gs=a,rt=c}up(e)}else(o.subtreeFlags&8772)!==0&&i!==null?(i.return=o,K=i):up(e)}}function up(e){for(;K!==null;){var t=K;if((t.flags&8772)!==0){var n=t.alternate;try{if((t.flags&8772)!==0)switch(t.tag){case 0:case 11:case 15:rt||Ba(5,t);break;case 1:var r=t.stateNode;if(t.flags&4&&!rt)if(n===null)r.componentDidMount();else{var o=t.elementType===t.type?n.memoizedProps:Wt(t.type,n.memoizedProps);r.componentDidUpdate(o,n.memoizedState,r.__reactInternalSnapshotBeforeUpdate)}var i=t.updateQueue;i!==null&&Yh(t,i,r);break;case 3:var s=t.updateQueue;if(s!==null){if(n=null,t.child!==null)switch(t.child.tag){case 5:n=t.child.stateNode;break;case 1:n=t.child.stateNode}Yh(t,s,n)}break;case 5:var a=t.stateNode;if(n===null&&t.flags&4){n=a;var l=t.memoizedProps;switch(t.type){case"button":case"input":case"select":case"textarea":l.autoFocus&&n.focus();break;case"img":l.src&&(n.src=l.src)}}break;case 6:break;case 4:break;case 12:break;case 13:if(t.memoizedState===null){var c=t.alternate;if(c!==null){var u=c.memoizedState;if(u!==null){var d=u.dehydrated;d!==null&&ki(d)}}}break;case 19:case 17:case 21:case 22:case 23:case 25:break;default:throw Error(N(163))}rt||t.flags&512&&Pu(t)}catch(p){Ne(t,t.return,p)}}if(t===e){K=null;break}if(n=t.sibling,n!==null){n.return=t.return,K=n;break}K=t.return}}function dp(e){for(;K!==null;){var t=K;if(t===e){K=null;break}var n=t.sibling;if(n!==null){n.return=t.return,K=n;break}K=t.return}}function fp(e){for(;K!==null;){var t=K;try{switch(t.tag){case 0:case 11:case 15:var n=t.return;try{Ba(4,t)}catch(l){Ne(t,n,l)}break;case 1:var r=t.stateNode;if(typeof r.componentDidMount=="function"){var o=t.return;try{r.componentDidMount()}catch(l){Ne(t,o,l)}}var i=t.return;try{Pu(t)}catch(l){Ne(t,i,l)}break;case 5:var s=t.return;try{Pu(t)}catch(l){Ne(t,s,l)}}}catch(l){Ne(t,t.return,l)}if(t===e){K=null;break}var a=t.sibling;if(a!==null){a.return=t.return,K=a;break}K=t.return}}var aw=Math.ceil,ha=Pn.ReactCurrentDispatcher,Qd=Pn.ReactCurrentOwner,zt=Pn.ReactCurrentBatchConfig,me=0,Ye=null,je=null,Ze=0,xt=0,oo=rr(0),We=0,Li=null,Er=0,Ua=0,Xd=0,ui=null,ft=null,qd=0,Po=1/0,dn=null,pa=!1,Iu=null,Hn=null,ys=!1,_n=null,ma=0,di=0,Ou=null,Fs=-1,zs=0;function ct(){return(me&6)!==0?ze():Fs!==-1?Fs:Fs=ze()}function Wn(e){return(e.mode&1)===0?1:(me&2)!==0&&Ze!==0?Ze&-Ze:Hx.transition!==null?(zs===0&&(zs=Fg()),zs):(e=ye,e!==0||(e=window.event,e=e===void 0?16:Wg(e.type)),e)}function Xt(e,t,n,r){if(50<di)throw di=0,Ou=null,Error(N(185));Ui(e,n,r),((me&2)===0||e!==Ye)&&(e===Ye&&((me&2)===0&&(Ua|=n),We===4&&$n(e,Ze)),yt(e,r),n===1&&me===0&&(t.mode&1)===0&&(Po=ze()+500,za&&or()))}function yt(e,t){var n=e.callbackNode;H2(e,t);var r=Zs(e,e===Ye?Ze:0);if(r===0)n!==null&&bh(n),e.callbackNode=null,e.callbackPriority=0;else if(t=r&-r,e.callbackPriority!==t){if(n!=null&&bh(n),t===1)e.tag===0?Ux(hp.bind(null,e)):u1(hp.bind(null,e)),zx(function(){(me&6)===0&&or()}),n=null;else{switch(zg(r)){case 1:n=Sd;break;case 4:n=Ng;break;case 16:n=qs;break;case 536870912:n=_g;break;default:n=qs}n=ly(n,ty.bind(null,e))}e.callbackPriority=t,e.callbackNode=n}}function ty(e,t){if(Fs=-1,zs=0,(me&6)!==0)throw Error(N(327));var n=e.callbackNode;if(vo()&&e.callbackNode!==n)return null;var r=Zs(e,e===Ye?Ze:0);if(r===0)return null;if((r&30)!==0||(r&e.expiredLanes)!==0||t)t=ga(e,r);else{t=r;var o=me;me|=2;var i=ry();(Ye!==e||Ze!==t)&&(dn=null,Po=ze()+500,br(e,t));do try{uw();break}catch(a){ny(e,a)}while(1);Nd(),ha.current=i,me=o,je!==null?t=0:(Ye=null,Ze=0,t=We)}if(t!==0){if(t===2&&(o=nu(e),o!==0&&(r=o,t=Au(e,o))),t===1)throw n=Li,br(e,0),$n(e,r),yt(e,ze()),n;if(t===6)$n(e,r);else{if(o=e.current.alternate,(r&30)===0&&!lw(o)&&(t=ga(e,r),t===2&&(i=nu(e),i!==0&&(r=i,t=Au(e,i))),t===1))throw n=Li,br(e,0),$n(e,r),yt(e,ze()),n;switch(e.finishedWork=o,e.finishedLanes=r,t){case 0:case 1:throw Error(N(345));case 2:fr(e,ft,dn);break;case 3:if($n(e,r),(r&130023424)===r&&(t=qd+500-ze(),10<t)){if(Zs(e,0)!==0)break;if(o=e.suspendedLanes,(o&r)!==r){ct(),e.pingedLanes|=e.suspendedLanes&o;break}e.timeoutHandle=uu(fr.bind(null,e,ft,dn),t);break}fr(e,ft,dn);break;case 4:if($n(e,r),(r&4194240)===r)break;for(t=e.eventTimes,o=-1;0<r;){var s=31-Qt(r);i=1<<s,s=t[s],s>o&&(o=s),r&=~i}if(r=o,r=ze()-r,r=(120>r?120:480>r?480:1080>r?1080:1920>r?1920:3e3>r?3e3:4320>r?4320:1960*aw(r/1960))-r,10<r){e.timeoutHandle=uu(fr.bind(null,e,ft,dn),r);break}fr(e,ft,dn);break;case 5:fr(e,ft,dn);break;default:throw Error(N(329))}}}return yt(e,ze()),e.callbackNode===n?ty.bind(null,e):null}function Au(e,t){var n=ui;return e.current.memoizedState.isDehydrated&&(br(e,t).flags|=256),e=ga(e,t),e!==2&&(t=ft,ft=n,t!==null&&Du(t)),e}function Du(e){ft===null?ft=e:ft.push.apply(ft,e)}function lw(e){for(var t=e;;){if(t.flags&16384){var n=t.updateQueue;if(n!==null&&(n=n.stores,n!==null))for(var r=0;r<n.length;r++){var o=n[r],i=o.getSnapshot;o=o.value;try{if(!qt(i(),o))return!1}catch{return!1}}}if(n=t.child,t.subtreeFlags&16384&&n!==null)n.return=t,t=n;else{if(t===e)break;for(;t.sibling===null;){if(t.return===null||t.return===e)return!0;t=t.return}t.sibling.return=t.return,t=t.sibling}}return!0}function $n(e,t){for(t&=~Xd,t&=~Ua,e.suspendedLanes|=t,e.pingedLanes&=~t,e=e.expirationTimes;0<t;){var n=31-Qt(t),r=1<<n;e[n]=-1,t&=~r}}function hp(e){if((me&6)!==0)throw Error(N(327));vo();var t=Zs(e,0);if((t&1)===0)return yt(e,ze()),null;var n=ga(e,t);if(e.tag!==0&&n===2){var r=nu(e);r!==0&&(t=r,n=Au(e,r))}if(n===1)throw n=Li,br(e,0),$n(e,t),yt(e,ze()),n;if(n===6)throw Error(N(345));return e.finishedWork=e.current.alternate,e.finishedLanes=t,fr(e,ft,dn),yt(e,ze()),null}function Zd(e,t){var n=me;me|=1;try{return e(t)}finally{me=n,me===0&&(Po=ze()+500,za&&or())}}function Ir(e){_n!==null&&_n.tag===0&&(me&6)===0&&vo();var t=me;me|=1;var n=zt.transition,r=ye;try{if(zt.transition=null,ye=1,e)return e()}finally{ye=r,zt.transition=n,me=t,(me&6)===0&&or()}}function Jd(){xt=oo.current,Pe(oo)}function br(e,t){e.finishedWork=null,e.finishedLanes=0;var n=e.timeoutHandle;if(n!==-1&&(e.timeoutHandle=-1,Fx(n)),je!==null)for(n=je.return;n!==null;){var r=n;switch(Rd(r),r.tag){case 1:r=r.type.childContextTypes,r!=null&&ra();break;case 3:So(),Pe(mt),Pe(it),Bd();break;case 5:jd(r);break;case 4:So();break;case 13:Pe(Me);break;case 19:Pe(Me);break;case 10:_d(r.type._context);break;case 22:case 23:Jd()}n=n.return}if(Ye=e,je=e=Gn(e.current,null),Ze=xt=t,We=0,Li=null,Xd=Ua=Er=0,ft=ui=null,vr!==null){for(t=0;t<vr.length;t++)if(n=vr[t],r=n.interleaved,r!==null){n.interleaved=null;var o=r.next,i=n.pending;if(i!==null){var s=i.next;i.next=o,r.next=s}n.pending=r}vr=null}return e}function ny(e,t){do{var n=je;try{if(Nd(),Ls.current=fa,da){for(var r=$e.memoizedState;r!==null;){var o=r.queue;o!==null&&(o.pending=null),r=r.next}da=!1}if(Tr=0,Ge=Ue=$e=null,li=!1,Mi=0,Qd.current=null,n===null||n.return===null){We=1,Li=t,je=null;break}e:{var i=e,s=n.return,a=n,l=t;if(t=Ze,a.flags|=32768,l!==null&&typeof l=="object"&&typeof l.then=="function"){var c=l,u=a,d=u.tag;if((u.mode&1)===0&&(d===0||d===11||d===15)){var p=u.alternate;p?(u.updateQueue=p.updateQueue,u.memoizedState=p.memoizedState,u.lanes=p.lanes):(u.updateQueue=null,u.memoizedState=null)}var y=ep(s);if(y!==null){y.flags&=-257,tp(y,s,a,i,t),y.mode&1&&Jh(i,c,t),t=y,l=c;var w=t.updateQueue;if(w===null){var x=new Set;x.add(l),t.updateQueue=x}else w.add(l);break e}else{if((t&1)===0){Jh(i,c,t),ef();break e}l=Error(N(426))}}else if(Ie&&a.mode&1){var b=ep(s);if(b!==null){(b.flags&65536)===0&&(b.flags|=256),tp(b,s,a,i,t),$d(ko(l,a));break e}}i=l=ko(l,a),We!==4&&(We=2),ui===null?ui=[i]:ui.push(i),i=s;do{switch(i.tag){case 3:i.flags|=65536,t&=-t,i.lanes|=t;var g=z1(i,l,t);Kh(i,g);break e;case 1:a=l;var h=i.type,m=i.stateNode;if((i.flags&128)===0&&(typeof h.getDerivedStateFromError=="function"||m!==null&&typeof m.componentDidCatch=="function"&&(Hn===null||!Hn.has(m)))){i.flags|=65536,t&=-t,i.lanes|=t;var S=V1(i,a,t);Kh(i,S);break e}}i=i.return}while(i!==null)}iy(n)}catch(E){t=E,je===n&&n!==null&&(je=n=n.return);continue}break}while(1)}function ry(){var e=ha.current;return ha.current=fa,e===null?fa:e}function ef(){(We===0||We===3||We===2)&&(We=4),Ye===null||(Er&268435455)===0&&(Ua&268435455)===0||$n(Ye,Ze)}function ga(e,t){var n=me;me|=2;var r=ry();(Ye!==e||Ze!==t)&&(dn=null,br(e,t));do try{cw();break}catch(o){ny(e,o)}while(1);if(Nd(),me=n,ha.current=r,je!==null)throw Error(N(261));return Ye=null,Ze=0,We}function cw(){for(;je!==null;)oy(je)}function uw(){for(;je!==null&&!L2();)oy(je)}function oy(e){var t=ay(e.alternate,e,xt);e.memoizedProps=e.pendingProps,t===null?iy(e):je=t,Qd.current=null}function iy(e){var t=e;do{var n=t.alternate;if(e=t.return,(t.flags&32768)===0){if(n=nw(n,t,xt),n!==null){je=n;return}}else{if(n=rw(n,t),n!==null){n.flags&=32767,je=n;return}if(e!==null)e.flags|=32768,e.subtreeFlags=0,e.deletions=null;else{We=6,je=null;return}}if(t=t.sibling,t!==null){je=t;return}je=t=e}while(t!==null);We===0&&(We=5)}function fr(e,t,n){var r=ye,o=zt.transition;try{zt.transition=null,ye=1,dw(e,t,n,r)}finally{zt.transition=o,ye=r}return null}function dw(e,t,n,r){do vo();while(_n!==null);if((me&6)!==0)throw Error(N(327));n=e.finishedWork;var o=e.finishedLanes;if(n===null)return null;if(e.finishedWork=null,e.finishedLanes=0,n===e.current)throw Error(N(177));e.callbackNode=null,e.callbackPriority=0;var i=n.lanes|n.childLanes;if(W2(e,i),e===Ye&&(je=Ye=null,Ze=0),(n.subtreeFlags&2064)===0&&(n.flags&2064)===0||ys||(ys=!0,ly(qs,function(){return vo(),null})),i=(n.flags&15990)!==0,(n.subtreeFlags&15990)!==0||i){i=zt.transition,zt.transition=null;var s=ye;ye=1;var a=me;me|=4,Qd.current=null,iw(e,n),J1(n,e),Dx(lu),Js=!!au,lu=au=null,e.current=n,sw(n),N2(),me=a,ye=s,zt.transition=i}else e.current=n;if(ys&&(ys=!1,_n=e,ma=o),i=e.pendingLanes,i===0&&(Hn=null),z2(n.stateNode),yt(e,ze()),t!==null)for(r=e.onRecoverableError,n=0;n<t.length;n++)o=t[n],r(o.value,{componentStack:o.stack,digest:o.digest});if(pa)throw pa=!1,e=Iu,Iu=null,e;return(ma&1)!==0&&e.tag!==0&&vo(),i=e.pendingLanes,(i&1)!==0?e===Ou?di++:(di=0,Ou=e):di=0,or(),null}function vo(){if(_n!==null){var e=zg(ma),t=zt.transition,n=ye;try{if(zt.transition=null,ye=16>e?16:e,_n===null)var r=!1;else{if(e=_n,_n=null,ma=0,(me&6)!==0)throw Error(N(331));var o=me;for(me|=4,K=e.current;K!==null;){var i=K,s=i.child;if((K.flags&16)!==0){var a=i.deletions;if(a!==null){for(var l=0;l<a.length;l++){var c=a[l];for(K=c;K!==null;){var u=K;switch(u.tag){case 0:case 11:case 15:ci(8,u,i)}var d=u.child;if(d!==null)d.return=u,K=d;else for(;K!==null;){u=K;var p=u.sibling,y=u.return;if(X1(u),u===c){K=null;break}if(p!==null){p.return=y,K=p;break}K=y}}}var w=i.alternate;if(w!==null){var x=w.child;if(x!==null){w.child=null;do{var b=x.sibling;x.sibling=null,x=b}while(x!==null)}}K=i}}if((i.subtreeFlags&2064)!==0&&s!==null)s.return=i,K=s;else e:for(;K!==null;){if(i=K,(i.flags&2048)!==0)switch(i.tag){case 0:case 11:case 15:ci(9,i,i.return)}var g=i.sibling;if(g!==null){g.return=i.return,K=g;break e}K=i.return}}var h=e.current;for(K=h;K!==null;){s=K;var m=s.child;if((s.subtreeFlags&2064)!==0&&m!==null)m.return=s,K=m;else e:for(s=h;K!==null;){if(a=K,(a.flags&2048)!==0)try{switch(a.tag){case 0:case 11:case 15:Ba(9,a)}}catch(E){Ne(a,a.return,E)}if(a===s){K=null;break e}var S=a.sibling;if(S!==null){S.return=a.return,K=S;break e}K=a.return}}if(me=o,or(),on&&typeof on.onPostCommitFiberRoot=="function")try{on.onPostCommitFiberRoot($a,e)}catch{}r=!0}return r}finally{ye=n,zt.transition=t}}return!1}function pp(e,t,n){t=ko(n,t),t=z1(e,t,1),e=Un(e,t,1),t=ct(),e!==null&&(Ui(e,1,t),yt(e,t))}function Ne(e,t,n){if(e.tag===3)pp(e,e,n);else for(;t!==null;){if(t.tag===3){pp(t,e,n);break}else if(t.tag===1){var r=t.stateNode;if(typeof t.type.getDerivedStateFromError=="function"||typeof r.componentDidCatch=="function"&&(Hn===null||!Hn.has(r))){e=ko(n,e),e=V1(t,e,1),t=Un(t,e,1),e=ct(),t!==null&&(Ui(t,1,e),yt(t,e));break}}t=t.return}}function fw(e,t,n){var r=e.pingCache;r!==null&&r.delete(t),t=ct(),e.pingedLanes|=e.suspendedLanes&n,Ye===e&&(Ze&n)===n&&(We===4||We===3&&(Ze&130023424)===Ze&&500>ze()-qd?br(e,0):Xd|=n),yt(e,t)}function sy(e,t){t===0&&((e.mode&1)===0?t=1:(t=as,as<<=1,(as&130023424)===0&&(as=4194304)));var n=ct();e=bn(e,t),e!==null&&(Ui(e,t,n),yt(e,n))}function hw(e){var t=e.memoizedState,n=0;t!==null&&(n=t.retryLane),sy(e,n)}function pw(e,t){var n=0;switch(e.tag){case 13:var r=e.stateNode,o=e.memoizedState;o!==null&&(n=o.retryLane);break;case 19:r=e.stateNode;break;default:throw Error(N(314))}r!==null&&r.delete(t),sy(e,n)}var ay;ay=function(e,t,n){if(e!==null)if(e.memoizedProps!==t.pendingProps||mt.current)ht=!0;else{if((e.lanes&n)===0&&(t.flags&128)===0)return ht=!1,tw(e,t,n);ht=(e.flags&131072)!==0}else ht=!1,Ie&&(t.flags&1048576)!==0&&d1(t,sa,t.index);switch(t.lanes=0,t.tag){case 2:var r=t.type;_s(e,t),e=t.pendingProps;var o=wo(t,it.current);yo(t,n),o=Hd(null,t,r,e,o,n);var i=Wd();return t.flags|=1,typeof o=="object"&&o!==null&&typeof o.render=="function"&&o.$$typeof===void 0?(t.tag=1,t.memoizedState=null,t.updateQueue=null,gt(r)?(i=!0,oa(t)):i=!1,t.memoizedState=o.state!==null&&o.state!==void 0?o.state:null,zd(t),o.updater=ja,t.stateNode=o,o._reactInternals=t,yu(t,r,e,n),t=wu(null,t,r,!0,i,n)):(t.tag=0,Ie&&i&&Md(t),lt(null,t,o,n),t=t.child),t;case 16:r=t.elementType;e:{switch(_s(e,t),e=t.pendingProps,o=r._init,r=o(r._payload),t.type=r,o=t.tag=gw(r),e=Wt(r,e),o){case 0:t=xu(null,t,r,e,n);break e;case 1:t=op(null,t,r,e,n);break e;case 11:t=np(null,t,r,e,n);break e;case 14:t=rp(null,t,r,Wt(r.type,e),n);break e}throw Error(N(306,r,""))}return t;case 0:return r=t.type,o=t.pendingProps,o=t.elementType===r?o:Wt(r,o),xu(e,t,r,o,n);case 1:return r=t.type,o=t.pendingProps,o=t.elementType===r?o:Wt(r,o),op(e,t,r,o,n);case 3:e:{if(H1(t),e===null)throw Error(N(387));r=t.pendingProps,i=t.memoizedState,o=i.element,y1(e,t),ca(t,r,null,n);var s=t.memoizedState;if(r=s.element,i.isDehydrated)if(i={element:r,isDehydrated:!1,cache:s.cache,pendingSuspenseBoundaries:s.pendingSuspenseBoundaries,transitions:s.transitions},t.updateQueue.baseState=i,t.memoizedState=i,t.flags&256){o=ko(Error(N(423)),t),t=ip(e,t,r,n,o);break e}else if(r!==o){o=ko(Error(N(424)),t),t=ip(e,t,r,n,o);break e}else for(wt=Bn(t.stateNode.containerInfo.firstChild),bt=t,Ie=!0,Kt=null,n=m1(t,null,r,n),t.child=n;n;)n.flags=n.flags&-3|4096,n=n.sibling;else{if(bo(),r===o){t=Cn(e,t,n);break e}lt(e,t,r,n)}t=t.child}return t;case 5:return v1(t),e===null&&pu(t),r=t.type,o=t.pendingProps,i=e!==null?e.memoizedProps:null,s=o.children,cu(r,o)?s=null:i!==null&&cu(r,i)&&(t.flags|=32),U1(e,t),lt(e,t,s,n),t.child;case 6:return e===null&&pu(t),null;case 13:return W1(e,t,n);case 4:return Vd(t,t.stateNode.containerInfo),r=t.pendingProps,e===null?t.child=Co(t,null,r,n):lt(e,t,r,n),t.child;case 11:return r=t.type,o=t.pendingProps,o=t.elementType===r?o:Wt(r,o),np(e,t,r,o,n);case 7:return lt(e,t,t.pendingProps,n),t.child;case 8:return lt(e,t,t.pendingProps.children,n),t.child;case 12:return lt(e,t,t.pendingProps.children,n),t.child;case 10:e:{if(r=t.type._context,o=t.pendingProps,i=t.memoizedProps,s=o.value,Ce(aa,r._currentValue),r._currentValue=s,i!==null)if(qt(i.value,s)){if(i.children===o.children&&!mt.current){t=Cn(e,t,n);break e}}else for(i=t.child,i!==null&&(i.return=t);i!==null;){var a=i.dependencies;if(a!==null){s=i.child;for(var l=a.firstContext;l!==null;){if(l.context===r){if(i.tag===1){l=gn(-1,n&-n),l.tag=2;var c=i.updateQueue;if(c!==null){c=c.shared;var u=c.pending;u===null?l.next=l:(l.next=u.next,u.next=l),c.pending=l}}i.lanes|=n,l=i.alternate,l!==null&&(l.lanes|=n),mu(i.return,n,t),a.lanes|=n;break}l=l.next}}else if(i.tag===10)s=i.type===t.type?null:i.child;else if(i.tag===18){if(s=i.return,s===null)throw Error(N(341));s.lanes|=n,a=s.alternate,a!==null&&(a.lanes|=n),mu(s,n,t),s=i.sibling}else s=i.child;if(s!==null)s.return=i;else for(s=i;s!==null;){if(s===t){s=null;break}if(i=s.sibling,i!==null){i.return=s.return,s=i;break}s=s.return}i=s}lt(e,t,o.children,n),t=t.child}return t;case 9:return o=t.type,r=t.pendingProps.children,yo(t,n),o=Vt(o),r=r(o),t.flags|=1,lt(e,t,r,n),t.child;case 14:return r=t.type,o=Wt(r,t.pendingProps),o=Wt(r.type,o),rp(e,t,r,o,n);case 15:return j1(e,t,t.type,t.pendingProps,n);case 17:return r=t.type,o=t.pendingProps,o=t.elementType===r?o:Wt(r,o),_s(e,t),t.tag=1,gt(r)?(e=!0,oa(t)):e=!1,yo(t,n),F1(t,r,o),yu(t,r,o,n),wu(null,t,r,!0,e,n);case 19:return G1(e,t,n);case 22:return B1(e,t,n)}throw Error(N(156,t.tag))};function ly(e,t){return Lg(e,t)}function mw(e,t,n,r){this.tag=e,this.key=n,this.sibling=this.child=this.return=this.stateNode=this.type=this.elementType=null,this.index=0,this.ref=null,this.pendingProps=t,this.dependencies=this.memoizedState=this.updateQueue=this.memoizedProps=null,this.mode=r,this.subtreeFlags=this.flags=0,this.deletions=null,this.childLanes=this.lanes=0,this.alternate=null}function Ft(e,t,n,r){return new mw(e,t,n,r)}function tf(e){return e=e.prototype,!(!e||!e.isReactComponent)}function gw(e){if(typeof e=="function")return tf(e)?1:0;if(e!=null){if(e=e.$$typeof,e===wd)return 11;if(e===bd)return 14}return 2}function Gn(e,t){var n=e.alternate;return n===null?(n=Ft(e.tag,t,e.key,e.mode),n.elementType=e.elementType,n.type=e.type,n.stateNode=e.stateNode,n.alternate=e,e.alternate=n):(n.pendingProps=t,n.type=e.type,n.flags=0,n.subtreeFlags=0,n.deletions=null),n.flags=e.flags&14680064,n.childLanes=e.childLanes,n.lanes=e.lanes,n.child=e.child,n.memoizedProps=e.memoizedProps,n.memoizedState=e.memoizedState,n.updateQueue=e.updateQueue,t=e.dependencies,n.dependencies=t===null?null:{lanes:t.lanes,firstContext:t.firstContext},n.sibling=e.sibling,n.index=e.index,n.ref=e.ref,n}function Vs(e,t,n,r,o,i){var s=2;if(r=e,typeof e=="function")tf(e)&&(s=1);else if(typeof e=="string")s=5;else e:switch(e){case Yr:return Cr(n.children,o,i,t);case xd:s=8,o|=8;break;case jc:return e=Ft(12,n,t,o|2),e.elementType=jc,e.lanes=i,e;case Bc:return e=Ft(13,n,t,o),e.elementType=Bc,e.lanes=i,e;case Uc:return e=Ft(19,n,t,o),e.elementType=Uc,e.lanes=i,e;case vg:return Ha(n,o,i,t);default:if(typeof e=="object"&&e!==null)switch(e.$$typeof){case gg:s=10;break e;case yg:s=9;break e;case wd:s=11;break e;case bd:s=14;break e;case In:s=16,r=null;break e}throw Error(N(130,e==null?e:typeof e,""))}return t=Ft(s,n,t,o),t.elementType=e,t.type=r,t.lanes=i,t}function Cr(e,t,n,r){return e=Ft(7,e,r,t),e.lanes=n,e}function Ha(e,t,n,r){return e=Ft(22,e,r,t),e.elementType=vg,e.lanes=n,e.stateNode={isHidden:!1},e}function Jl(e,t,n){return e=Ft(6,e,null,t),e.lanes=n,e}function ec(e,t,n){return t=Ft(4,e.children!==null?e.children:[],e.key,t),t.lanes=n,t.stateNode={containerInfo:e.containerInfo,pendingChildren:null,implementation:e.implementation},t}function yw(e,t,n,r,o){this.tag=t,this.containerInfo=e,this.finishedWork=this.pingCache=this.current=this.pendingChildren=null,this.timeoutHandle=-1,this.callbackNode=this.pendingContext=this.context=null,this.callbackPriority=0,this.eventTimes=$l(0),this.expirationTimes=$l(-1),this.entangledLanes=this.finishedLanes=this.mutableReadLanes=this.expiredLanes=this.pingedLanes=this.suspendedLanes=this.pendingLanes=0,this.entanglements=$l(0),this.identifierPrefix=r,this.onRecoverableError=o,this.mutableSourceEagerHydrationData=null}function nf(e,t,n,r,o,i,s,a,l){return e=new yw(e,t,n,a,l),t===1?(t=1,i===!0&&(t|=8)):t=0,i=Ft(3,null,null,t),e.current=i,i.stateNode=e,i.memoizedState={element:r,isDehydrated:n,cache:null,transitions:null,pendingSuspenseBoundaries:null},zd(i),e}function vw(e,t,n){var r=3<arguments.length&&arguments[3]!==void 0?arguments[3]:null;return{$$typeof:Kr,key:r==null?null:""+r,children:e,containerInfo:t,implementation:n}}function cy(e){if(!e)return Jn;e=e._reactInternals;e:{if(Rr(e)!==e||e.tag!==1)throw Error(N(170));var t=e;do{switch(t.tag){case 3:t=t.stateNode.context;break e;case 1:if(gt(t.type)){t=t.stateNode.__reactInternalMemoizedMergedChildContext;break e}}t=t.return}while(t!==null);throw Error(N(171))}if(e.tag===1){var n=e.type;if(gt(n))return c1(e,n,t)}return t}function uy(e,t,n,r,o,i,s,a,l){return e=nf(n,r,!0,e,o,i,s,a,l),e.context=cy(null),n=e.current,r=ct(),o=Wn(n),i=gn(r,o),i.callback=t!=null?t:null,Un(n,i,o),e.current.lanes=o,Ui(e,o,r),yt(e,r),e}function Wa(e,t,n,r){var o=t.current,i=ct(),s=Wn(o);return n=cy(n),t.context===null?t.context=n:t.pendingContext=n,t=gn(i,s),t.payload={element:e},r=r===void 0?null:r,r!==null&&(t.callback=r),e=Un(o,t,s),e!==null&&(Xt(e,o,s,i),$s(e,o,s)),s}function ya(e){if(e=e.current,!e.child)return null;switch(e.child.tag){case 5:return e.child.stateNode;default:return e.child.stateNode}}function mp(e,t){if(e=e.memoizedState,e!==null&&e.dehydrated!==null){var n=e.retryLane;e.retryLane=n!==0&&n<t?n:t}}function rf(e,t){mp(e,t),(e=e.alternate)&&mp(e,t)}function xw(){return null}var dy=typeof reportError=="function"?reportError:function(e){console.error(e)};function of(e){this._internalRoot=e}Ga.prototype.render=of.prototype.render=function(e){var t=this._internalRoot;if(t===null)throw Error(N(409));Wa(e,t,null,null)};Ga.prototype.unmount=of.prototype.unmount=function(){var e=this._internalRoot;if(e!==null){this._internalRoot=null;var t=e.containerInfo;Ir(function(){Wa(null,e,null,null)}),t[wn]=null}};function Ga(e){this._internalRoot=e}Ga.prototype.unstable_scheduleHydration=function(e){if(e){var t=Bg();e={blockedOn:null,target:e,priority:t};for(var n=0;n<Rn.length&&t!==0&&t<Rn[n].priority;n++);Rn.splice(n,0,e),n===0&&Hg(e)}};function sf(e){return!(!e||e.nodeType!==1&&e.nodeType!==9&&e.nodeType!==11)}function Ka(e){return!(!e||e.nodeType!==1&&e.nodeType!==9&&e.nodeType!==11&&(e.nodeType!==8||e.nodeValue!==" react-mount-point-unstable "))}function gp(){}function ww(e,t,n,r,o){if(o){if(typeof r=="function"){var i=r;r=function(){var c=ya(s);i.call(c)}}var s=uy(t,r,e,0,null,!1,!1,"",gp);return e._reactRootContainer=s,e[wn]=s.current,Ei(e.nodeType===8?e.parentNode:e),Ir(),s}for(;o=e.lastChild;)e.removeChild(o);if(typeof r=="function"){var a=r;r=function(){var c=ya(l);a.call(c)}}var l=nf(e,0,!1,null,null,!1,!1,"",gp);return e._reactRootContainer=l,e[wn]=l.current,Ei(e.nodeType===8?e.parentNode:e),Ir(function(){Wa(t,l,n,r)}),l}function Ya(e,t,n,r,o){var i=n._reactRootContainer;if(i){var s=i;if(typeof o=="function"){var a=o;o=function(){var l=ya(s);a.call(l)}}Wa(t,s,e,o)}else s=ww(n,t,e,o,r);return ya(s)}Vg=function(e){switch(e.tag){case 3:var t=e.stateNode;if(t.current.memoizedState.isDehydrated){var n=Jo(t.pendingLanes);n!==0&&(kd(t,n|1),yt(t,ze()),(me&6)===0&&(Po=ze()+500,or()))}break;case 13:Ir(function(){var r=bn(e,1);if(r!==null){var o=ct();Xt(r,e,1,o)}}),rf(e,1)}};Pd=function(e){if(e.tag===13){var t=bn(e,134217728);if(t!==null){var n=ct();Xt(t,e,134217728,n)}rf(e,134217728)}};jg=function(e){if(e.tag===13){var t=Wn(e),n=bn(e,t);if(n!==null){var r=ct();Xt(n,e,t,r)}rf(e,t)}};Bg=function(){return ye};Ug=function(e,t){var n=ye;try{return ye=e,t()}finally{ye=n}};Jc=function(e,t,n){switch(t){case"input":if(Gc(e,n),t=n.name,n.type==="radio"&&t!=null){for(n=e;n.parentNode;)n=n.parentNode;for(n=n.querySelectorAll("input[name="+JSON.stringify(""+t)+'][type="radio"]'),t=0;t<n.length;t++){var r=n[t];if(r!==e&&r.form===e.form){var o=Fa(r);if(!o)throw Error(N(90));wg(r),Gc(r,o)}}}break;case"textarea":Cg(e,n);break;case"select":t=n.value,t!=null&&ho(e,!!n.multiple,t,!1)}};Og=Zd;Ag=Ir;var bw={usingClientEntryPoint:!1,Events:[Wi,Zr,Fa,Eg,Ig,Zd]},Bo={findFiberByHostInstance:yr,bundleType:0,version:"18.3.1",rendererPackageName:"react-dom"},Cw={bundleType:Bo.bundleType,version:Bo.version,rendererPackageName:Bo.rendererPackageName,rendererConfig:Bo.rendererConfig,overrideHookState:null,overrideHookStateDeletePath:null,overrideHookStateRenamePath:null,overrideProps:null,overridePropsDeletePath:null,overridePropsRenamePath:null,setErrorHandler:null,setSuspenseHandler:null,scheduleUpdate:null,currentDispatcherRef:Pn.ReactCurrentDispatcher,findHostInstanceByFiber:function(e){return e=Rg(e),e===null?null:e.stateNode},findFiberByHostInstance:Bo.findFiberByHostInstance||xw,findHostInstancesForRefresh:null,scheduleRefresh:null,scheduleRoot:null,setRefreshHandler:null,getCurrentFiber:null,reconcilerVersion:"18.3.1-next-f1338f8080-20240426"};if(typeof __REACT_DEVTOOLS_GLOBAL_HOOK__!="undefined"){var vs=__REACT_DEVTOOLS_GLOBAL_HOOK__;if(!vs.isDisabled&&vs.supportsFiber)try{$a=vs.inject(Cw),on=vs}catch{}}kt.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED=bw;kt.createPortal=function(e,t){var n=2<arguments.length&&arguments[2]!==void 0?arguments[2]:null;if(!sf(t))throw Error(N(200));return vw(e,t,null,n)};kt.createRoot=function(e,t){if(!sf(e))throw Error(N(299));var n=!1,r="",o=dy;return t!=null&&(t.unstable_strictMode===!0&&(n=!0),t.identifierPrefix!==void 0&&(r=t.identifierPrefix),t.onRecoverableError!==void 0&&(o=t.onRecoverableError)),t=nf(e,1,!1,null,null,n,!1,r,o),e[wn]=t.current,Ei(e.nodeType===8?e.parentNode:e),new of(t)};kt.findDOMNode=function(e){if(e==null)return null;if(e.nodeType===1)return e;var t=e._reactInternals;if(t===void 0)throw typeof e.render=="function"?Error(N(188)):(e=Object.keys(e).join(","),Error(N(268,e)));return e=Rg(t),e=e===null?null:e.stateNode,e};kt.flushSync=function(e){return Ir(e)};kt.hydrate=function(e,t,n){if(!Ka(t))throw Error(N(200));return Ya(null,e,t,!0,n)};kt.hydrateRoot=function(e,t,n){if(!sf(e))throw Error(N(405));var r=n!=null&&n.hydratedSources||null,o=!1,i="",s=dy;if(n!=null&&(n.unstable_strictMode===!0&&(o=!0),n.identifierPrefix!==void 0&&(i=n.identifierPrefix),n.onRecoverableError!==void 0&&(s=n.onRecoverableError)),t=uy(t,null,e,1,n!=null?n:null,o,!1,i,s),e[wn]=t.current,Ei(e),r)for(e=0;e<r.length;e++)n=r[e],o=n._getVersion,o=o(n._source),t.mutableSourceEagerHydrationData==null?t.mutableSourceEagerHydrationData=[n,o]:t.mutableSourceEagerHydrationData.push(n,o);return new Ga(t)};kt.render=function(e,t,n){if(!Ka(t))throw Error(N(200));return Ya(null,e,t,!1,n)};kt.unmountComponentAtNode=function(e){if(!Ka(e))throw Error(N(40));return e._reactRootContainer?(Ir(function(){Ya(null,null,e,!1,function(){e._reactRootContainer=null,e[wn]=null})}),!0):!1};kt.unstable_batchedUpdates=Zd;kt.unstable_renderSubtreeIntoContainer=function(e,t,n,r){if(!Ka(n))throw Error(N(200));if(e==null||e._reactInternals===void 0)throw Error(N(38));return Ya(e,t,n,!1,r)};kt.version="18.3.1-next-f1338f8080-20240426";function fy(){if(!(typeof __REACT_DEVTOOLS_GLOBAL_HOOK__=="undefined"||typeof __REACT_DEVTOOLS_GLOBAL_HOOK__.checkDCE!="function"))try{__REACT_DEVTOOLS_GLOBAL_HOOK__.checkDCE(fy)}catch(e){console.error(e)}}fy(),Ra.exports=kt;var Sw=Ra.exports,kw=og({__proto__:null,default:Sw},[Ra.exports]),yp=Ra.exports;zc.createRoot=yp.createRoot,zc.hydrateRoot=yp.hydrateRoot;var Qa={exports:{}},ve={};/** @license React v16.13.1
 * react-is.production.min.js
 *
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */var Qe=typeof Symbol=="function"&&Symbol.for,af=Qe?Symbol.for("react.element"):60103,lf=Qe?Symbol.for("react.portal"):60106,Xa=Qe?Symbol.for("react.fragment"):60107,qa=Qe?Symbol.for("react.strict_mode"):60108,Za=Qe?Symbol.for("react.profiler"):60114,Ja=Qe?Symbol.for("react.provider"):60109,el=Qe?Symbol.for("react.context"):60110,cf=Qe?Symbol.for("react.async_mode"):60111,tl=Qe?Symbol.for("react.concurrent_mode"):60111,nl=Qe?Symbol.for("react.forward_ref"):60112,rl=Qe?Symbol.for("react.suspense"):60113,Pw=Qe?Symbol.for("react.suspense_list"):60120,ol=Qe?Symbol.for("react.memo"):60115,il=Qe?Symbol.for("react.lazy"):60116,Tw=Qe?Symbol.for("react.block"):60121,Ew=Qe?Symbol.for("react.fundamental"):60117,Iw=Qe?Symbol.for("react.responder"):60118,Ow=Qe?Symbol.for("react.scope"):60119;function Tt(e){if(typeof e=="object"&&e!==null){var t=e.$$typeof;switch(t){case af:switch(e=e.type,e){case cf:case tl:case Xa:case Za:case qa:case rl:return e;default:switch(e=e&&e.$$typeof,e){case el:case nl:case il:case ol:case Ja:return e;default:return t}}case lf:return t}}}function hy(e){return Tt(e)===tl}ve.AsyncMode=cf;ve.ConcurrentMode=tl;ve.ContextConsumer=el;ve.ContextProvider=Ja;ve.Element=af;ve.ForwardRef=nl;ve.Fragment=Xa;ve.Lazy=il;ve.Memo=ol;ve.Portal=lf;ve.Profiler=Za;ve.StrictMode=qa;ve.Suspense=rl;ve.isAsyncMode=function(e){return hy(e)||Tt(e)===cf};ve.isConcurrentMode=hy;ve.isContextConsumer=function(e){return Tt(e)===el};ve.isContextProvider=function(e){return Tt(e)===Ja};ve.isElement=function(e){return typeof e=="object"&&e!==null&&e.$$typeof===af};ve.isForwardRef=function(e){return Tt(e)===nl};ve.isFragment=function(e){return Tt(e)===Xa};ve.isLazy=function(e){return Tt(e)===il};ve.isMemo=function(e){return Tt(e)===ol};ve.isPortal=function(e){return Tt(e)===lf};ve.isProfiler=function(e){return Tt(e)===Za};ve.isStrictMode=function(e){return Tt(e)===qa};ve.isSuspense=function(e){return Tt(e)===rl};ve.isValidElementType=function(e){return typeof e=="string"||typeof e=="function"||e===Xa||e===tl||e===Za||e===qa||e===rl||e===Pw||typeof e=="object"&&e!==null&&(e.$$typeof===il||e.$$typeof===ol||e.$$typeof===Ja||e.$$typeof===el||e.$$typeof===nl||e.$$typeof===Ew||e.$$typeof===Iw||e.$$typeof===Ow||e.$$typeof===Tw)};ve.typeOf=Tt;Qa.exports=ve;function Aw(e){function t(R,F,V,X,k){for(var U=0,M=0,ue=0,te=0,le,A,H=0,Z=0,q,ae=q=le=0,ie=0,ge=0,we=0,xe=0,st=V.length,he=st-1,Te,oe="",De="",_r="",Fr="",Bt;ie<st;){if(A=V.charCodeAt(ie),ie===he&&M+te+ue+U!==0&&(M!==0&&(A=M===47?10:47),te=ue=U=0,st++,he++),M+te+ue+U===0){if(ie===he&&(0<ge&&(oe=oe.replace(p,"")),0<oe.trim().length)){switch(A){case 32:case 9:case 59:case 13:case 10:break;default:oe+=V.charAt(ie)}A=59}switch(A){case 123:for(oe=oe.trim(),le=oe.charCodeAt(0),q=1,xe=++ie;ie<st;){switch(A=V.charCodeAt(ie)){case 123:q++;break;case 125:q--;break;case 47:switch(A=V.charCodeAt(ie+1)){case 42:case 47:e:{for(ae=ie+1;ae<he;++ae)switch(V.charCodeAt(ae)){case 47:if(A===42&&V.charCodeAt(ae-1)===42&&ie+2!==ae){ie=ae+1;break e}break;case 10:if(A===47){ie=ae+1;break e}}ie=ae}}break;case 91:A++;case 40:A++;case 34:case 39:for(;ie++<he&&V.charCodeAt(ie)!==A;);}if(q===0)break;ie++}switch(q=V.substring(xe,ie),le===0&&(le=(oe=oe.replace(d,"").trim()).charCodeAt(0)),le){case 64:switch(0<ge&&(oe=oe.replace(p,"")),A=oe.charCodeAt(1),A){case 100:case 109:case 115:case 45:ge=F;break;default:ge=z}if(q=t(F,ge,q,A,k+1),xe=q.length,0<$&&(ge=n(z,oe,we),Bt=a(3,q,ge,F,se,J,xe,A,k,X),oe=ge.join(""),Bt!==void 0&&(xe=(q=Bt.trim()).length)===0&&(A=0,q="")),0<xe)switch(A){case 115:oe=oe.replace(T,s);case 100:case 109:case 45:q=oe+"{"+q+"}";break;case 107:oe=oe.replace(h,"$1 $2"),q=oe+"{"+q+"}",q=Y===1||Y===2&&i("@"+q,3)?"@-webkit-"+q+"@"+q:"@"+q;break;default:q=oe+q,X===112&&(q=(De+=q,""))}else q="";break;default:q=t(F,n(F,oe,we),q,X,k+1)}_r+=q,q=we=ge=ae=le=0,oe="",A=V.charCodeAt(++ie);break;case 125:case 59:if(oe=(0<ge?oe.replace(p,""):oe).trim(),1<(xe=oe.length))switch(ae===0&&(le=oe.charCodeAt(0),le===45||96<le&&123>le)&&(xe=(oe=oe.replace(" ",":")).length),0<$&&(Bt=a(1,oe,F,R,se,J,De.length,X,k,X))!==void 0&&(xe=(oe=Bt.trim()).length)===0&&(oe="\0\0"),le=oe.charCodeAt(0),A=oe.charCodeAt(1),le){case 0:break;case 64:if(A===105||A===99){Fr+=oe+V.charAt(ie);break}default:oe.charCodeAt(xe-1)!==58&&(De+=o(oe,le,A,oe.charCodeAt(2)))}we=ge=ae=le=0,oe="",A=V.charCodeAt(++ie)}}switch(A){case 13:case 10:M===47?M=0:1+le===0&&X!==107&&0<oe.length&&(ge=1,oe+="\0"),0<$*G&&a(0,oe,F,R,se,J,De.length,X,k,X),J=1,se++;break;case 59:case 125:if(M+te+ue+U===0){J++;break}default:switch(J++,Te=V.charAt(ie),A){case 9:case 32:if(te+U+M===0)switch(H){case 44:case 58:case 9:case 32:Te="";break;default:A!==32&&(Te=" ")}break;case 0:Te="\\0";break;case 12:Te="\\f";break;case 11:Te="\\v";break;case 38:te+M+U===0&&(ge=we=1,Te="\f"+Te);break;case 108:if(te+M+U+j===0&&0<ae)switch(ie-ae){case 2:H===112&&V.charCodeAt(ie-3)===58&&(j=H);case 8:Z===111&&(j=Z)}break;case 58:te+M+U===0&&(ae=ie);break;case 44:M+ue+te+U===0&&(ge=1,Te+="\r");break;case 34:case 39:M===0&&(te=te===A?0:te===0?A:te);break;case 91:te+M+ue===0&&U++;break;case 93:te+M+ue===0&&U--;break;case 41:te+M+U===0&&ue--;break;case 40:if(te+M+U===0){if(le===0)switch(2*H+3*Z){case 533:break;default:le=1}ue++}break;case 64:M+ue+te+U+ae+q===0&&(q=1);break;case 42:case 47:if(!(0<te+U+ue))switch(M){case 0:switch(2*A+3*V.charCodeAt(ie+1)){case 235:M=47;break;case 220:xe=ie,M=42}break;case 42:A===47&&H===42&&xe+2!==ie&&(V.charCodeAt(xe+2)===33&&(De+=V.substring(xe,ie+1)),Te="",M=0)}}M===0&&(oe+=Te)}Z=H,H=A,ie++}if(xe=De.length,0<xe){if(ge=F,0<$&&(Bt=a(2,De,ge,R,se,J,xe,X,k,X),Bt!==void 0&&(De=Bt).length===0))return Fr+De+_r;if(De=ge.join(",")+"{"+De+"}",Y*j!==0){switch(Y!==2||i(De,2)||(j=0),j){case 111:De=De.replace(S,":-moz-$1")+De;break;case 112:De=De.replace(m,"::-webkit-input-$1")+De.replace(m,"::-moz-$1")+De.replace(m,":-ms-input-$1")+De}j=0}}return Fr+De+_r}function n(R,F,V){var X=F.trim().split(b);F=X;var k=X.length,U=R.length;switch(U){case 0:case 1:var M=0;for(R=U===0?"":R[0]+" ";M<k;++M)F[M]=r(R,F[M],V).trim();break;default:var ue=M=0;for(F=[];M<k;++M)for(var te=0;te<U;++te)F[ue++]=r(R[te]+" ",X[M],V).trim()}return F}function r(R,F,V){var X=F.charCodeAt(0);switch(33>X&&(X=(F=F.trim()).charCodeAt(0)),X){case 38:return F.replace(g,"$1"+R.trim());case 58:return R.trim()+F.replace(g,"$1"+R.trim());default:if(0<1*V&&0<F.indexOf("\f"))return F.replace(g,(R.charCodeAt(0)===58?"":"$1")+R.trim())}return R+F}function o(R,F,V,X){var k=R+";",U=2*F+3*V+4*X;if(U===944){R=k.indexOf(":",9)+1;var M=k.substring(R,k.length-1).trim();return M=k.substring(0,R).trim()+M+";",Y===1||Y===2&&i(M,1)?"-webkit-"+M+M:M}if(Y===0||Y===2&&!i(k,1))return k;switch(U){case 1015:return k.charCodeAt(10)===97?"-webkit-"+k+k:k;case 951:return k.charCodeAt(3)===116?"-webkit-"+k+k:k;case 963:return k.charCodeAt(5)===110?"-webkit-"+k+k:k;case 1009:if(k.charCodeAt(4)!==100)break;case 969:case 942:return"-webkit-"+k+k;case 978:return"-webkit-"+k+"-moz-"+k+k;case 1019:case 983:return"-webkit-"+k+"-moz-"+k+"-ms-"+k+k;case 883:if(k.charCodeAt(8)===45)return"-webkit-"+k+k;if(0<k.indexOf("image-set(",11))return k.replace(re,"$1-webkit-$2")+k;break;case 932:if(k.charCodeAt(4)===45)switch(k.charCodeAt(5)){case 103:return"-webkit-box-"+k.replace("-grow","")+"-webkit-"+k+"-ms-"+k.replace("grow","positive")+k;case 115:return"-webkit-"+k+"-ms-"+k.replace("shrink","negative")+k;case 98:return"-webkit-"+k+"-ms-"+k.replace("basis","preferred-size")+k}return"-webkit-"+k+"-ms-"+k+k;case 964:return"-webkit-"+k+"-ms-flex-"+k+k;case 1023:if(k.charCodeAt(8)!==99)break;return M=k.substring(k.indexOf(":",15)).replace("flex-","").replace("space-between","justify"),"-webkit-box-pack"+M+"-webkit-"+k+"-ms-flex-pack"+M+k;case 1005:return w.test(k)?k.replace(y,":-webkit-")+k.replace(y,":-moz-")+k:k;case 1e3:switch(M=k.substring(13).trim(),F=M.indexOf("-")+1,M.charCodeAt(0)+M.charCodeAt(F)){case 226:M=k.replace(E,"tb");break;case 232:M=k.replace(E,"tb-rl");break;case 220:M=k.replace(E,"lr");break;default:return k}return"-webkit-"+k+"-ms-"+M+k;case 1017:if(k.indexOf("sticky",9)===-1)break;case 975:switch(F=(k=R).length-10,M=(k.charCodeAt(F)===33?k.substring(0,F):k).substring(R.indexOf(":",7)+1).trim(),U=M.charCodeAt(0)+(M.charCodeAt(7)|0)){case 203:if(111>M.charCodeAt(8))break;case 115:k=k.replace(M,"-webkit-"+M)+";"+k;break;case 207:case 102:k=k.replace(M,"-webkit-"+(102<U?"inline-":"")+"box")+";"+k.replace(M,"-webkit-"+M)+";"+k.replace(M,"-ms-"+M+"box")+";"+k}return k+";";case 938:if(k.charCodeAt(5)===45)switch(k.charCodeAt(6)){case 105:return M=k.replace("-items",""),"-webkit-"+k+"-webkit-box-"+M+"-ms-flex-"+M+k;case 115:return"-webkit-"+k+"-ms-flex-item-"+k.replace(O,"")+k;default:return"-webkit-"+k+"-ms-flex-line-pack"+k.replace("align-content","").replace(O,"")+k}break;case 973:case 989:if(k.charCodeAt(3)!==45||k.charCodeAt(4)===122)break;case 931:case 953:if(_.test(R)===!0)return(M=R.substring(R.indexOf(":")+1)).charCodeAt(0)===115?o(R.replace("stretch","fill-available"),F,V,X).replace(":fill-available",":stretch"):k.replace(M,"-webkit-"+M)+k.replace(M,"-moz-"+M.replace("fill-",""))+k;break;case 962:if(k="-webkit-"+k+(k.charCodeAt(5)===102?"-ms-"+k:"")+k,V+X===211&&k.charCodeAt(13)===105&&0<k.indexOf("transform",10))return k.substring(0,k.indexOf(";",27)+1).replace(x,"$1-webkit-$2")+k}return k}function i(R,F){var V=R.indexOf(F===1?":":"{"),X=R.substring(0,F!==3?V:10);return V=R.substring(V+1,R.length-1),B(F!==2?X:X.replace(L,"$1"),V,F)}function s(R,F){var V=o(F,F.charCodeAt(0),F.charCodeAt(1),F.charCodeAt(2));return V!==F+";"?V.replace(I," or ($1)").substring(4):"("+F+")"}function a(R,F,V,X,k,U,M,ue,te,le){for(var A=0,H=F,Z;A<$;++A)switch(Z=ee[A].call(u,R,H,V,X,k,U,M,ue,te,le)){case void 0:case!1:case!0:case null:break;default:H=Z}if(H!==F)return H}function l(R){switch(R){case void 0:case null:$=ee.length=0;break;default:if(typeof R=="function")ee[$++]=R;else if(typeof R=="object")for(var F=0,V=R.length;F<V;++F)l(R[F]);else G=!!R|0}return l}function c(R){return R=R.prefix,R!==void 0&&(B=null,R?typeof R!="function"?Y=1:(Y=2,B=R):Y=0),c}function u(R,F){var V=R;if(33>V.charCodeAt(0)&&(V=V.trim()),W=V,V=[W],0<$){var X=a(-1,F,V,V,se,J,0,0,0,0);X!==void 0&&typeof X=="string"&&(F=X)}var k=t(z,V,F,0,0);return 0<$&&(X=a(-2,k,V,V,se,J,k.length,0,0,0),X!==void 0&&(k=X)),W="",j=0,J=se=1,k}var d=/^\0+/g,p=/[\0\r\f]/g,y=/: */g,w=/zoo|gra/,x=/([,: ])(transform)/g,b=/,\r+?/g,g=/([\t\r\n ])*\f?&/g,h=/@(k\w+)\s*(\S*)\s*/,m=/::(place)/g,S=/:(read-only)/g,E=/[svh]\w+-[tblr]{2}/,T=/\(\s*(.*)\s*\)/g,I=/([\s\S]*?);/g,O=/-self|flex-/g,L=/[^]*?(:[rp][el]a[\w-]+)[^]*/,_=/stretch|:\s*\w+\-(?:conte|avail)/,re=/([^-])(image-set\()/,J=1,se=1,j=0,Y=1,z=[],ee=[],$=0,B=null,G=0,W="";return u.use=l,u.set=c,e!==void 0&&c(e),u}var Dw={animationIterationCount:1,borderImageOutset:1,borderImageSlice:1,borderImageWidth:1,boxFlex:1,boxFlexGroup:1,boxOrdinalGroup:1,columnCount:1,columns:1,flex:1,flexGrow:1,flexPositive:1,flexShrink:1,flexNegative:1,flexOrder:1,gridRow:1,gridRowEnd:1,gridRowSpan:1,gridRowStart:1,gridColumn:1,gridColumnEnd:1,gridColumnSpan:1,gridColumnStart:1,msGridRow:1,msGridRowSpan:1,msGridColumn:1,msGridColumnSpan:1,fontWeight:1,lineHeight:1,opacity:1,order:1,orphans:1,tabSize:1,widows:1,zIndex:1,zoom:1,WebkitLineClamp:1,fillOpacity:1,floodOpacity:1,stopOpacity:1,strokeDasharray:1,strokeDashoffset:1,strokeMiterlimit:1,strokeOpacity:1,strokeWidth:1};function Mw(e){var t=Object.create(null);return function(n){return t[n]===void 0&&(t[n]=e(n)),t[n]}}var Rw=/^((children|dangerouslySetInnerHTML|key|ref|autoFocus|defaultValue|defaultChecked|innerHTML|suppressContentEditableWarning|suppressHydrationWarning|valueLink|abbr|accept|acceptCharset|accessKey|action|allow|allowUserMedia|allowPaymentRequest|allowFullScreen|allowTransparency|alt|async|autoComplete|autoPlay|capture|cellPadding|cellSpacing|challenge|charSet|checked|cite|classID|className|cols|colSpan|content|contentEditable|contextMenu|controls|controlsList|coords|crossOrigin|data|dateTime|decoding|default|defer|dir|disabled|disablePictureInPicture|disableRemotePlayback|download|draggable|encType|enterKeyHint|fetchpriority|fetchPriority|form|formAction|formEncType|formMethod|formNoValidate|formTarget|frameBorder|headers|height|hidden|high|href|hrefLang|htmlFor|httpEquiv|id|inputMode|integrity|is|keyParams|keyType|kind|label|lang|list|loading|loop|low|marginHeight|marginWidth|max|maxLength|media|mediaGroup|method|min|minLength|multiple|muted|name|nonce|noValidate|open|optimum|pattern|placeholder|playsInline|poster|preload|profile|radioGroup|readOnly|referrerPolicy|rel|required|reversed|role|rows|rowSpan|sandbox|scope|scoped|scrolling|seamless|selected|shape|size|sizes|slot|span|spellCheck|src|srcDoc|srcLang|srcSet|start|step|style|summary|tabIndex|target|title|translate|type|useMap|value|width|wmode|wrap|about|datatype|inlist|prefix|property|resource|typeof|vocab|autoCapitalize|autoCorrect|autoSave|color|incremental|fallback|inert|itemProp|itemScope|itemType|itemID|itemRef|on|option|results|security|unselectable|accentHeight|accumulate|additive|alignmentBaseline|allowReorder|alphabetic|amplitude|arabicForm|ascent|attributeName|attributeType|autoReverse|azimuth|baseFrequency|baselineShift|baseProfile|bbox|begin|bias|by|calcMode|capHeight|clip|clipPathUnits|clipPath|clipRule|colorInterpolation|colorInterpolationFilters|colorProfile|colorRendering|contentScriptType|contentStyleType|cursor|cx|cy|d|decelerate|descent|diffuseConstant|direction|display|divisor|dominantBaseline|dur|dx|dy|edgeMode|elevation|enableBackground|end|exponent|externalResourcesRequired|fill|fillOpacity|fillRule|filter|filterRes|filterUnits|floodColor|floodOpacity|focusable|fontFamily|fontSize|fontSizeAdjust|fontStretch|fontStyle|fontVariant|fontWeight|format|from|fr|fx|fy|g1|g2|glyphName|glyphOrientationHorizontal|glyphOrientationVertical|glyphRef|gradientTransform|gradientUnits|hanging|horizAdvX|horizOriginX|ideographic|imageRendering|in|in2|intercept|k|k1|k2|k3|k4|kernelMatrix|kernelUnitLength|kerning|keyPoints|keySplines|keyTimes|lengthAdjust|letterSpacing|lightingColor|limitingConeAngle|local|markerEnd|markerMid|markerStart|markerHeight|markerUnits|markerWidth|mask|maskContentUnits|maskUnits|mathematical|mode|numOctaves|offset|opacity|operator|order|orient|orientation|origin|overflow|overlinePosition|overlineThickness|panose1|paintOrder|pathLength|patternContentUnits|patternTransform|patternUnits|pointerEvents|points|pointsAtX|pointsAtY|pointsAtZ|preserveAlpha|preserveAspectRatio|primitiveUnits|r|radius|refX|refY|renderingIntent|repeatCount|repeatDur|requiredExtensions|requiredFeatures|restart|result|rotate|rx|ry|scale|seed|shapeRendering|slope|spacing|specularConstant|specularExponent|speed|spreadMethod|startOffset|stdDeviation|stemh|stemv|stitchTiles|stopColor|stopOpacity|strikethroughPosition|strikethroughThickness|string|stroke|strokeDasharray|strokeDashoffset|strokeLinecap|strokeLinejoin|strokeMiterlimit|strokeOpacity|strokeWidth|surfaceScale|systemLanguage|tableValues|targetX|targetY|textAnchor|textDecoration|textRendering|textLength|to|transform|u1|u2|underlinePosition|underlineThickness|unicode|unicodeBidi|unicodeRange|unitsPerEm|vAlphabetic|vHanging|vIdeographic|vMathematical|values|vectorEffect|version|vertAdvY|vertOriginX|vertOriginY|viewBox|viewTarget|visibility|widths|wordSpacing|writingMode|x|xHeight|x1|x2|xChannelSelector|xlinkActuate|xlinkArcrole|xlinkHref|xlinkRole|xlinkShow|xlinkTitle|xlinkType|xmlBase|xmlns|xmlnsXlink|xmlLang|xmlSpace|y|y1|y2|yChannelSelector|z|zoomAndPan|for|class|autofocus)|(([Dd][Aa][Tt][Aa]|[Aa][Rr][Ii][Aa]|x)-.*))$/,vp=Mw(function(e){return Rw.test(e)||e.charCodeAt(0)===111&&e.charCodeAt(1)===110&&e.charCodeAt(2)<91}),uf=Qa.exports,$w={childContextTypes:!0,contextType:!0,contextTypes:!0,defaultProps:!0,displayName:!0,getDefaultProps:!0,getDerivedStateFromError:!0,getDerivedStateFromProps:!0,mixins:!0,propTypes:!0,type:!0},Lw={name:!0,length:!0,prototype:!0,caller:!0,callee:!0,arguments:!0,arity:!0},Nw={$$typeof:!0,render:!0,defaultProps:!0,displayName:!0,propTypes:!0},py={$$typeof:!0,compare:!0,defaultProps:!0,displayName:!0,propTypes:!0,type:!0},df={};df[uf.ForwardRef]=Nw;df[uf.Memo]=py;function xp(e){return uf.isMemo(e)?py:df[e.$$typeof]||$w}var _w=Object.defineProperty,Fw=Object.getOwnPropertyNames,wp=Object.getOwnPropertySymbols,zw=Object.getOwnPropertyDescriptor,Vw=Object.getPrototypeOf,bp=Object.prototype;function my(e,t,n){if(typeof t!="string"){if(bp){var r=Vw(t);r&&r!==bp&&my(e,r,n)}var o=Fw(t);wp&&(o=o.concat(wp(t)));for(var i=xp(e),s=xp(t),a=0;a<o.length;++a){var l=o[a];if(!Lw[l]&&!(n&&n[l])&&!(s&&s[l])&&!(i&&i[l])){var c=zw(t,l);try{_w(e,l,c)}catch{}}}}return e}var jw=my;function Yt(){return(Yt=Object.assign||function(e){for(var t=1;t<arguments.length;t++){var n=arguments[t];for(var r in n)Object.prototype.hasOwnProperty.call(n,r)&&(e[r]=n[r])}return e}).apply(this,arguments)}var Cp=function(e,t){for(var n=[e[0]],r=0,o=t.length;r<o;r+=1)n.push(t[r],e[r+1]);return n},Mu=function(e){return e!==null&&typeof e=="object"&&(e.toString?e.toString():Object.prototype.toString.call(e))==="[object Object]"&&!Qa.exports.typeOf(e)},va=Object.freeze([]),Kn=Object.freeze({});function To(e){return typeof e=="function"}function Sp(e){return e.displayName||e.name||"Component"}function ff(e){return e&&typeof e.styledComponentId=="string"}var Eo=typeof process!="undefined"&&process.env!==void 0&&({}.REACT_APP_SC_ATTR||{}.SC_ATTR)||"data-styled",hf=typeof window!="undefined"&&"HTMLElement"in window,Bw=Boolean(typeof SC_DISABLE_SPEEDY=="boolean"?SC_DISABLE_SPEEDY:typeof process!="undefined"&&process.env!==void 0&&({}.REACT_APP_SC_DISABLE_SPEEDY!==void 0&&{}.REACT_APP_SC_DISABLE_SPEEDY!==""?{}.REACT_APP_SC_DISABLE_SPEEDY!=="false"&&{}.REACT_APP_SC_DISABLE_SPEEDY:{}.SC_DISABLE_SPEEDY!==void 0&&{}.SC_DISABLE_SPEEDY!==""?{}.SC_DISABLE_SPEEDY!=="false"&&{}.SC_DISABLE_SPEEDY:!1)),Uw={};function Or(e){for(var t=arguments.length,n=new Array(t>1?t-1:0),r=1;r<t;r++)n[r-1]=arguments[r];throw new Error("An error occurred. See https://git.io/JUIaE#"+e+" for more information."+(n.length>0?" Args: "+n.join(", "):""))}var Hw=function(){function e(n){this.groupSizes=new Uint32Array(512),this.length=512,this.tag=n}var t=e.prototype;return t.indexOfGroup=function(n){for(var r=0,o=0;o<n;o++)r+=this.groupSizes[o];return r},t.insertRules=function(n,r){if(n>=this.groupSizes.length){for(var o=this.groupSizes,i=o.length,s=i;n>=s;)(s<<=1)<0&&Or(16,""+n);this.groupSizes=new Uint32Array(s),this.groupSizes.set(o),this.length=s;for(var a=i;a<s;a++)this.groupSizes[a]=0}for(var l=this.indexOfGroup(n+1),c=0,u=r.length;c<u;c++)this.tag.insertRule(l,r[c])&&(this.groupSizes[n]++,l++)},t.clearGroup=function(n){if(n<this.length){var r=this.groupSizes[n],o=this.indexOfGroup(n),i=o+r;this.groupSizes[n]=0;for(var s=o;s<i;s++)this.tag.deleteRule(o)}},t.getGroup=function(n){var r="";if(n>=this.length||this.groupSizes[n]===0)return r;for(var o=this.groupSizes[n],i=this.indexOfGroup(n),s=i+o,a=i;a<s;a++)r+=this.tag.getRule(a)+`/*!sc*/
`;return r},e}(),js=new Map,xa=new Map,fi=1,xs=function(e){if(js.has(e))return js.get(e);for(;xa.has(fi);)fi++;var t=fi++;return js.set(e,t),xa.set(t,e),t},Ww=function(e){return xa.get(e)},Gw=function(e,t){t>=fi&&(fi=t+1),js.set(e,t),xa.set(t,e)},Kw="style["+Eo+'][data-styled-version="5.3.11"]',Yw=new RegExp("^"+Eo+'\\.g(\\d+)\\[id="([\\w\\d-]+)"\\].*?"([^"]*)'),Qw=function(e,t,n){for(var r,o=n.split(","),i=0,s=o.length;i<s;i++)(r=o[i])&&e.registerName(t,r)},Xw=function(e,t){for(var n=(t.textContent||"").split(`/*!sc*/
`),r=[],o=0,i=n.length;o<i;o++){var s=n[o].trim();if(s){var a=s.match(Yw);if(a){var l=0|parseInt(a[1],10),c=a[2];l!==0&&(Gw(c,l),Qw(e,c,a[3]),e.getTag().insertRules(l,r)),r.length=0}else r.push(s)}}},qw=function(){return typeof __webpack_nonce__!="undefined"?__webpack_nonce__:null},gy=function(e){var t=document.head,n=e||t,r=document.createElement("style"),o=function(a){for(var l=a.childNodes,c=l.length;c>=0;c--){var u=l[c];if(u&&u.nodeType===1&&u.hasAttribute(Eo))return u}}(n),i=o!==void 0?o.nextSibling:null;r.setAttribute(Eo,"active"),r.setAttribute("data-styled-version","5.3.11");var s=qw();return s&&r.setAttribute("nonce",s),n.insertBefore(r,i),r},Zw=function(){function e(n){var r=this.element=gy(n);r.appendChild(document.createTextNode("")),this.sheet=function(o){if(o.sheet)return o.sheet;for(var i=document.styleSheets,s=0,a=i.length;s<a;s++){var l=i[s];if(l.ownerNode===o)return l}Or(17)}(r),this.length=0}var t=e.prototype;return t.insertRule=function(n,r){try{return this.sheet.insertRule(r,n),this.length++,!0}catch{return!1}},t.deleteRule=function(n){this.sheet.deleteRule(n),this.length--},t.getRule=function(n){var r=this.sheet.cssRules[n];return r!==void 0&&typeof r.cssText=="string"?r.cssText:""},e}(),Jw=function(){function e(n){var r=this.element=gy(n);this.nodes=r.childNodes,this.length=0}var t=e.prototype;return t.insertRule=function(n,r){if(n<=this.length&&n>=0){var o=document.createTextNode(r),i=this.nodes[n];return this.element.insertBefore(o,i||null),this.length++,!0}return!1},t.deleteRule=function(n){this.element.removeChild(this.nodes[n]),this.length--},t.getRule=function(n){return n<this.length?this.nodes[n].textContent:""},e}(),eb=function(){function e(n){this.rules=[],this.length=0}var t=e.prototype;return t.insertRule=function(n,r){return n<=this.length&&(this.rules.splice(n,0,r),this.length++,!0)},t.deleteRule=function(n){this.rules.splice(n,1),this.length--},t.getRule=function(n){return n<this.length?this.rules[n]:""},e}(),kp=hf,tb={isServer:!hf,useCSSOMInjection:!Bw},wa=function(){function e(n,r,o){n===void 0&&(n=Kn),r===void 0&&(r={}),this.options=Yt({},tb,{},n),this.gs=r,this.names=new Map(o),this.server=!!n.isServer,!this.server&&hf&&kp&&(kp=!1,function(i){for(var s=document.querySelectorAll(Kw),a=0,l=s.length;a<l;a++){var c=s[a];c&&c.getAttribute(Eo)!=="active"&&(Xw(i,c),c.parentNode&&c.parentNode.removeChild(c))}}(this))}e.registerId=function(n){return xs(n)};var t=e.prototype;return t.reconstructWithOptions=function(n,r){return r===void 0&&(r=!0),new e(Yt({},this.options,{},n),this.gs,r&&this.names||void 0)},t.allocateGSInstance=function(n){return this.gs[n]=(this.gs[n]||0)+1},t.getTag=function(){return this.tag||(this.tag=(o=(r=this.options).isServer,i=r.useCSSOMInjection,s=r.target,n=o?new eb(s):i?new Zw(s):new Jw(s),new Hw(n)));var n,r,o,i,s},t.hasNameForId=function(n,r){return this.names.has(n)&&this.names.get(n).has(r)},t.registerName=function(n,r){if(xs(n),this.names.has(n))this.names.get(n).add(r);else{var o=new Set;o.add(r),this.names.set(n,o)}},t.insertRules=function(n,r,o){this.registerName(n,r),this.getTag().insertRules(xs(n),o)},t.clearNames=function(n){this.names.has(n)&&this.names.get(n).clear()},t.clearRules=function(n){this.getTag().clearGroup(xs(n)),this.clearNames(n)},t.clearTag=function(){this.tag=void 0},t.toString=function(){return function(n){for(var r=n.getTag(),o=r.length,i="",s=0;s<o;s++){var a=Ww(s);if(a!==void 0){var l=n.names.get(a),c=r.getGroup(s);if(l&&c&&l.size){var u=Eo+".g"+s+'[id="'+a+'"]',d="";l!==void 0&&l.forEach(function(p){p.length>0&&(d+=p+",")}),i+=""+c+u+'{content:"'+d+`"}/*!sc*/
`}}}return i}(this)},e}(),nb=/(a)(d)/gi,Pp=function(e){return String.fromCharCode(e+(e>25?39:97))};function Ru(e){var t,n="";for(t=Math.abs(e);t>52;t=t/52|0)n=Pp(t%52)+n;return(Pp(t%52)+n).replace(nb,"$1-$2")}var io=function(e,t){for(var n=t.length;n;)e=33*e^t.charCodeAt(--n);return e},yy=function(e){return io(5381,e)};function vy(e){for(var t=0;t<e.length;t+=1){var n=e[t];if(To(n)&&!ff(n))return!1}return!0}var rb=yy("5.3.11"),ob=function(){function e(t,n,r){this.rules=t,this.staticRulesId="",this.isStatic=(r===void 0||r.isStatic)&&vy(t),this.componentId=n,this.baseHash=io(rb,n),this.baseStyle=r,wa.registerId(n)}return e.prototype.generateAndInjectStyles=function(t,n,r){var o=this.componentId,i=[];if(this.baseStyle&&i.push(this.baseStyle.generateAndInjectStyles(t,n,r)),this.isStatic&&!r.hash)if(this.staticRulesId&&n.hasNameForId(o,this.staticRulesId))i.push(this.staticRulesId);else{var s=Ar(this.rules,t,n,r).join(""),a=Ru(io(this.baseHash,s)>>>0);if(!n.hasNameForId(o,a)){var l=r(s,"."+a,void 0,o);n.insertRules(o,a,l)}i.push(a),this.staticRulesId=a}else{for(var c=this.rules.length,u=io(this.baseHash,r.hash),d="",p=0;p<c;p++){var y=this.rules[p];if(typeof y=="string")d+=y;else if(y){var w=Ar(y,t,n,r),x=Array.isArray(w)?w.join(""):w;u=io(u,x+p),d+=x}}if(d){var b=Ru(u>>>0);if(!n.hasNameForId(o,b)){var g=r(d,"."+b,void 0,o);n.insertRules(o,b,g)}i.push(b)}}return i.join(" ")},e}(),ib=/^\s*\/\/.*$/gm,sb=[":","[",".","#"];function ab(e){var t,n,r,o,i=e===void 0?Kn:e,s=i.options,a=s===void 0?Kn:s,l=i.plugins,c=l===void 0?va:l,u=new Aw(a),d=[],p=function(x){function b(g){if(g)try{x(g+"}")}catch{}}return function(g,h,m,S,E,T,I,O,L,_){switch(g){case 1:if(L===0&&h.charCodeAt(0)===64)return x(h+";"),"";break;case 2:if(O===0)return h+"/*|*/";break;case 3:switch(O){case 102:case 112:return x(m[0]+h),"";default:return h+(_===0?"/*|*/":"")}case-2:h.split("/*|*/}").forEach(b)}}}(function(x){d.push(x)}),y=function(x,b,g){return b===0&&sb.indexOf(g[n.length])!==-1||g.match(o)?x:"."+t};function w(x,b,g,h){h===void 0&&(h="&");var m=x.replace(ib,""),S=b&&g?g+" "+b+" { "+m+" }":m;return t=h,n=b,r=new RegExp("\\"+n+"\\b","g"),o=new RegExp("(\\"+n+"\\b){2,}"),u(g||!b?"":b,S)}return u.use([].concat(c,[function(x,b,g){x===2&&g.length&&g[0].lastIndexOf(n)>0&&(g[0]=g[0].replace(r,y))},p,function(x){if(x===-2){var b=d;return d=[],b}}])),w.hash=c.length?c.reduce(function(x,b){return b.name||Or(15),io(x,b.name)},5381).toString():"",w}var xy=Ke.createContext();xy.Consumer;var wy=Ke.createContext(),lb=(wy.Consumer,new wa),$u=ab();function by(){return v.exports.useContext(xy)||lb}function Cy(){return v.exports.useContext(wy)||$u}var Sy=function(){function e(t,n){var r=this;this.inject=function(o,i){i===void 0&&(i=$u);var s=r.name+i.hash;o.hasNameForId(r.id,s)||o.insertRules(r.id,s,i(r.rules,s,"@keyframes"))},this.toString=function(){return Or(12,String(r.name))},this.name=t,this.id="sc-keyframes-"+t,this.rules=n}return e.prototype.getName=function(t){return t===void 0&&(t=$u),this.name+t.hash},e}(),cb=/([A-Z])/,ub=/([A-Z])/g,db=/^ms-/,fb=function(e){return"-"+e.toLowerCase()};function Tp(e){return cb.test(e)?e.replace(ub,fb).replace(db,"-ms-"):e}var Ep=function(e){return e==null||e===!1||e===""};function Ar(e,t,n,r){if(Array.isArray(e)){for(var o,i=[],s=0,a=e.length;s<a;s+=1)(o=Ar(e[s],t,n,r))!==""&&(Array.isArray(o)?i.push.apply(i,o):i.push(o));return i}if(Ep(e))return"";if(ff(e))return"."+e.styledComponentId;if(To(e)){if(typeof(c=e)!="function"||c.prototype&&c.prototype.isReactComponent||!t)return e;var l=e(t);return Ar(l,t,n,r)}var c;return e instanceof Sy?n?(e.inject(n,r),e.getName(r)):e:Mu(e)?function u(d,p){var y,w,x=[];for(var b in d)d.hasOwnProperty(b)&&!Ep(d[b])&&(Array.isArray(d[b])&&d[b].isCss||To(d[b])?x.push(Tp(b)+":",d[b],";"):Mu(d[b])?x.push.apply(x,u(d[b],b)):x.push(Tp(b)+": "+(y=b,(w=d[b])==null||typeof w=="boolean"||w===""?"":typeof w!="number"||w===0||y in Dw||y.startsWith("--")?String(w).trim():w+"px")+";"));return p?[p+" {"].concat(x,["}"]):x}(e):e.toString()}var Ip=function(e){return Array.isArray(e)&&(e.isCss=!0),e};function de(e){for(var t=arguments.length,n=new Array(t>1?t-1:0),r=1;r<t;r++)n[r-1]=arguments[r];return To(e)||Mu(e)?Ip(Ar(Cp(va,[e].concat(n)))):n.length===0&&e.length===1&&typeof e[0]=="string"?e:Ip(Ar(Cp(e,n)))}var ky=function(e,t,n){return n===void 0&&(n=Kn),e.theme!==n.theme&&e.theme||t||n.theme},hb=/[!"#$%&'()*+,./:;<=>?@[\\\]^`{|}~-]+/g,pb=/(^-|-$)/g;function tc(e){return e.replace(hb,"-").replace(pb,"")}var pf=function(e){return Ru(yy(e)>>>0)};function ws(e){return typeof e=="string"&&!0}var Lu=function(e){return typeof e=="function"||typeof e=="object"&&e!==null&&!Array.isArray(e)},mb=function(e){return e!=="__proto__"&&e!=="constructor"&&e!=="prototype"};function gb(e,t,n){var r=e[n];Lu(t)&&Lu(r)?Py(r,t):e[n]=t}function Py(e){for(var t=arguments.length,n=new Array(t>1?t-1:0),r=1;r<t;r++)n[r-1]=arguments[r];for(var o=0,i=n;o<i.length;o++){var s=i[o];if(Lu(s))for(var a in s)mb(a)&&gb(e,s[a],a)}return e}var Ni=Ke.createContext();Ni.Consumer;function yb(e){var t=v.exports.useContext(Ni),n=v.exports.useMemo(function(){return function(r,o){if(!r)return Or(14);if(To(r)){var i=r(o);return i}return Array.isArray(r)||typeof r!="object"?Or(8):o?Yt({},o,{},r):r}(e.theme,t)},[e.theme,t]);return e.children?Ke.createElement(Ni.Provider,{value:n},e.children):null}var nc={};function Ty(e,t,n){var r=ff(e),o=!ws(e),i=t.attrs,s=i===void 0?va:i,a=t.componentId,l=a===void 0?function(h,m){var S=typeof h!="string"?"sc":tc(h);nc[S]=(nc[S]||0)+1;var E=S+"-"+pf("5.3.11"+S+nc[S]);return m?m+"-"+E:E}(t.displayName,t.parentComponentId):a,c=t.displayName,u=c===void 0?function(h){return ws(h)?"styled."+h:"Styled("+Sp(h)+")"}(e):c,d=t.displayName&&t.componentId?tc(t.displayName)+"-"+t.componentId:t.componentId||l,p=r&&e.attrs?Array.prototype.concat(e.attrs,s).filter(Boolean):s,y=t.shouldForwardProp;r&&e.shouldForwardProp&&(y=t.shouldForwardProp?function(h,m,S){return e.shouldForwardProp(h,m,S)&&t.shouldForwardProp(h,m,S)}:e.shouldForwardProp);var w,x=new ob(n,d,r?e.componentStyle:void 0),b=x.isStatic&&s.length===0,g=function(h,m){return function(S,E,T,I){var O=S.attrs,L=S.componentStyle,_=S.defaultProps,re=S.foldedComponentIds,J=S.shouldForwardProp,se=S.styledComponentId,j=S.target,Y=function(X,k,U){X===void 0&&(X=Kn);var M=Yt({},k,{theme:X}),ue={};return U.forEach(function(te){var le,A,H,Z=te;for(le in To(Z)&&(Z=Z(M)),Z)M[le]=ue[le]=le==="className"?(A=ue[le],H=Z[le],A&&H?A+" "+H:A||H):Z[le]}),[M,ue]}(ky(E,v.exports.useContext(Ni),_)||Kn,E,O),z=Y[0],ee=Y[1],$=function(X,k,U,M){var ue=by(),te=Cy(),le=k?X.generateAndInjectStyles(Kn,ue,te):X.generateAndInjectStyles(U,ue,te);return le}(L,I,z),B=T,G=ee.$as||E.$as||ee.as||E.as||j,W=ws(G),R=ee!==E?Yt({},E,{},ee):E,F={};for(var V in R)V[0]!=="$"&&V!=="as"&&(V==="forwardedAs"?F.as=R[V]:(J?J(V,vp,G):!W||vp(V))&&(F[V]=R[V]));return E.style&&ee.style!==E.style&&(F.style=Yt({},E.style,{},ee.style)),F.className=Array.prototype.concat(re,se,$!==se?$:null,E.className,ee.className).filter(Boolean).join(" "),F.ref=B,v.exports.createElement(G,F)}(w,h,m,b)};return g.displayName=u,(w=Ke.forwardRef(g)).attrs=p,w.componentStyle=x,w.displayName=u,w.shouldForwardProp=y,w.foldedComponentIds=r?Array.prototype.concat(e.foldedComponentIds,e.styledComponentId):va,w.styledComponentId=d,w.target=r?e.target:e,w.withComponent=function(h){var m=t.componentId,S=function(T,I){if(T==null)return{};var O,L,_={},re=Object.keys(T);for(L=0;L<re.length;L++)O=re[L],I.indexOf(O)>=0||(_[O]=T[O]);return _}(t,["componentId"]),E=m&&m+"-"+(ws(h)?h:tc(Sp(h)));return Ty(h,Yt({},S,{attrs:p,componentId:E}),n)},Object.defineProperty(w,"defaultProps",{get:function(){return this._foldedDefaultProps},set:function(h){this._foldedDefaultProps=r?Py({},e.defaultProps,h):h}}),Object.defineProperty(w,"toString",{value:function(){return"."+w.styledComponentId}}),o&&jw(w,e,{attrs:!0,componentStyle:!0,displayName:!0,foldedComponentIds:!0,shouldForwardProp:!0,styledComponentId:!0,target:!0,withComponent:!0}),w}var Nu=function(e){return function t(n,r,o){if(o===void 0&&(o=Kn),!Qa.exports.isValidElementType(r))return Or(1,String(r));var i=function(){return n(r,o,de.apply(void 0,arguments))};return i.withConfig=function(s){return t(n,r,Yt({},o,{},s))},i.attrs=function(s){return t(n,r,Yt({},o,{attrs:Array.prototype.concat(o.attrs,s).filter(Boolean)}))},i}(Ty,e)};["a","abbr","address","area","article","aside","audio","b","base","bdi","bdo","big","blockquote","body","br","button","canvas","caption","cite","code","col","colgroup","data","datalist","dd","del","details","dfn","dialog","div","dl","dt","em","embed","fieldset","figcaption","figure","footer","form","h1","h2","h3","h4","h5","h6","head","header","hgroup","hr","html","i","iframe","img","input","ins","kbd","keygen","label","legend","li","link","main","map","mark","marquee","menu","menuitem","meta","meter","nav","noscript","object","ol","optgroup","option","output","p","param","picture","pre","progress","q","rp","rt","ruby","s","samp","script","section","select","small","source","span","strong","style","sub","summary","sup","table","tbody","td","textarea","tfoot","th","thead","time","title","tr","track","u","ul","var","video","wbr","circle","clipPath","defs","ellipse","foreignObject","g","image","line","linearGradient","marker","mask","path","pattern","polygon","polyline","radialGradient","rect","stop","svg","text","textPath","tspan"].forEach(function(e){Nu[e]=Nu(e)});var vb=function(){function e(n,r){this.rules=n,this.componentId=r,this.isStatic=vy(n),wa.registerId(this.componentId+1)}var t=e.prototype;return t.createStyles=function(n,r,o,i){var s=i(Ar(this.rules,r,o,i).join(""),""),a=this.componentId+n;o.insertRules(a,a,s)},t.removeStyles=function(n,r){r.clearRules(this.componentId+n)},t.renderStyles=function(n,r,o,i){n>2&&wa.registerId(this.componentId+n),this.removeStyles(n,o),this.createStyles(n,r,o,i)},e}();function xb(e){for(var t=arguments.length,n=new Array(t>1?t-1:0),r=1;r<t;r++)n[r-1]=arguments[r];var o=de.apply(void 0,[e].concat(n)),i="sc-global-"+pf(JSON.stringify(o)),s=new vb(o,i);function a(c){var u=by(),d=Cy(),p=v.exports.useContext(Ni),y=v.exports.useRef(u.allocateGSInstance(i)).current;return u.server&&l(y,c,u,p,d),v.exports.useLayoutEffect(function(){if(!u.server)return l(y,c,u,p,d),function(){return s.removeStyles(y,u)}},[y,c,u,p,d]),null}function l(c,u,d,p,y){if(s.isStatic)s.renderStyles(c,Uw,d,y);else{var w=Yt({},u,{theme:ky(u,p,a.defaultProps)});s.renderStyles(c,w,d,y)}}return Ke.memo(a)}function mf(e){for(var t=arguments.length,n=new Array(t>1?t-1:0),r=1;r<t;r++)n[r-1]=arguments[r];var o=de.apply(void 0,[e].concat(n)).join(""),i=pf(o);return new Sy(i,o)}var C=Nu;function gf(){return window.GetParentResourceName?window.GetParentResourceName():"nui-frame-app"}const pt=()=>!window.invokeNative,wb=()=>{};async function Oe(e,t,n,r){const o={method:"post",headers:{"Content-Type":"application/json; charset=UTF-8"},body:JSON.stringify(t)};if(pt()&&n)return n;const i=gf(),s=r!=null?r:i;return await(await fetch(`https://${s}/${e}`,o)).json()}const rc={tag:"default",isFromHookCache:!0,logo:"https://cdn.discordapp.com/attachments/1093997802381656085/1126600893706551408/santa.png",smallLogo:"https://media.discordapp.net/attachments/1008191296030117948/1095025699590512698/Group_33.png",colors:{main:{50:"#ffe3ec",100:"#ffb4c7",200:"#fc84a2",300:"#f9537d",400:"#f62358",500:"#f20a45",600:"#ac0331",700:"#7c0022",800:"#4c0014",900:"#1f0007"},"main-opacity":{50:"rgba(242, 10, 69, 0.05)",100:"rgba(242, 10, 69, 0.1)",200:"rgba(242, 10, 69, 0.2)",300:"rgba(242, 10, 69, 0.3)",400:"rgba(242, 10, 69, 0.4)",500:"rgba(242, 10, 69, 0.5)",600:"rgba(242, 10, 69, 0.6)",700:"rgba(242, 10, 69, 0.7)",800:"rgba(242, 10, 69, 0.8)",900:"rgba(242, 10, 69, 0.9)"},red:{50:"#ffe1e1",100:"#ffb1b1",200:"#ff7f7f",300:"#ff4c4c",400:"#ff1a1a",500:"#e60000",600:"#b40000",700:"#810000",800:"#500000",900:"#210000"},"red-opacity":{50:"rgba(255, 29, 29, 0);",100:"rgba(255, 29, 29, 0.1);",200:"rgba(255, 29, 29, 0.2);",300:"rgba(255, 29, 29, 0.3);",400:"rgba(255, 29, 29, 0.4);",500:"rgba(255, 29, 29, 0.5);",600:"rgba(255, 29, 29, 0.6);",700:"rgba(255, 29, 29, 0.7);",800:"rgba(255, 29, 29, 0.8);",900:"rgba(255, 29, 29, 0.9);"},white:{50:"#f2f2f2",100:"#d9d9d9",200:"#bfbfbf",300:"#a6a6a6",400:"#8c8c8c",500:"#737373",600:"#595959",700:"#404040",800:"#262626",900:"#0d0d0d"},background:{50:"#f2f2f2",100:"#d9d9d9",200:"#bfbfbf",300:"#a6a6a6",400:"#8c8c8c",500:"#737373",600:"#595959",700:"#404040",800:"#262626",900:"#0d0d0d"}},borders:{}},ot=(e,t)=>{const n=v.exports.useRef(wb);v.exports.useEffect(()=>{n.current=t},[t]),v.exports.useEffect(()=>{const r=o=>{const{action:i,data:s}=o.data;n.current&&i===e&&n.current(s)};return window.addEventListener("message",r),()=>{window.removeEventListener("message",r)}},[e])};var Ey={exports:{}},sl={};/**
 * @license React
 * react-jsx-runtime.production.min.js
 *
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */var bb=Ke,Cb=Symbol.for("react.element"),Sb=Symbol.for("react.fragment"),kb=Object.prototype.hasOwnProperty,Pb=bb.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED.ReactCurrentOwner,Tb={key:!0,ref:!0,__self:!0,__source:!0};function Iy(e,t,n){var r,o={},i=null,s=null;n!==void 0&&(i=""+n),t.key!==void 0&&(i=""+t.key),t.ref!==void 0&&(s=t.ref);for(r in t)kb.call(t,r)&&!Tb.hasOwnProperty(r)&&(o[r]=t[r]);if(e&&e.defaultProps)for(r in t=e.defaultProps,t)o[r]===void 0&&(o[r]=t[r]);return{$$typeof:Cb,type:e,key:i,ref:s,props:o,_owner:Pb.current}}sl.Fragment=Sb;sl.jsx=Iy;sl.jsxs=Iy;Ey.exports=sl;const _u=Ey.exports.jsx,Oy=v.exports.createContext(null),Eb=5e3,Op=12;function Ib({children:e,customResource:t,customTheme:n}){const[r,o]=v.exports.useState(n!=null?n:rc),[i,s]=v.exports.useState(!1),[a,l]=v.exports.useState(1),[c,u]=v.exports.useState(null),[d]=v.exports.useState(gf()),p=async()=>{if(!i){console.log(`themes(${d}): attemping ${a}/${Op}`);try{const w=await Oe("getTheme",{},rc,t!=null?t:"vrp");if(w==null)throw new Error("Theme is undefined or null.");c&&clearTimeout(c),s(!0),o(w),console.log(`themes(${d}): theme found, using it.`);return}catch(w){console.error(`themes(${d}): error while fetching theme.`,w)}l(a+1)}},y=()=>{const w=n!=null?n:rc;o(w)};return v.exports.useEffect(()=>{if(pt()){console.log(`themes(${d}): running in browser, using custom or default theme.`),y();return}if(!i){if(a<Op&&!i){if(a===1){p();return}u(setTimeout(()=>{p()},Eb));return}console.log(`themes(${d}): attemps limit reached, using custom or default theme.`),y()}},[a]),ot("setTheme",w=>{o(w)}),_u(Oy.Provider,{value:{theme:r,setTheme:o},children:_u(yb,{theme:r,children:e})})}const Ay=()=>v.exports.useContext(Oy),Dy=v.exports.createContext(null),Ob=5e3,Ap=12;function Ab({children:e,customLang:t,customResource:n}){const[r,o]=v.exports.useState(t!=null?t:null),[i,s]=v.exports.useState(!1),[a,l]=v.exports.useState(1),[c,u]=v.exports.useState(null),[d]=v.exports.useState(gf()),p=b=>{if(b.includes(".")){const g=b.split(".");let h=r;return g.forEach(m=>{h=h[m]}),h}return r[b]},y=(b,...g)=>{if(!r)return b;const h=p(b);return h?g.length>0?h.replace(/{(\d+)}/g,(m,S)=>typeof g[S]!="undefined"?g[S]:m):h:b},w=async()=>{if(!i){console.log(`lang(${d}): attemping ${a}/${Ap}`);try{const b=await Oe("getLang",d,t,n!=null?n:"localization");if(y==null)throw new Error("Lang is undefined or null.");c&&clearTimeout(c),s(!0),o(b),console.log(`lang(${d}): lang found, using it.`);return}catch(b){console.error(`lang(${d}): error while fetching lang.`,b)}l(a+1)}},x=()=>{const b=t!=null?t:null;o(b)};return v.exports.useEffect(()=>{if(pt()){console.log(`lang(${d}): running in browser, using custom or no lang.`),x();return}if(!i){if(a<Ap&&!i){if(a===1){w();return}u(setTimeout(()=>{w()},Ob));return}console.log(`lang(${d}): attemps limit reached, using null.`),x()}},[a]),_u(Dy.Provider,{value:{t:y,lang:r,getT:p},children:e})}const Zt=()=>v.exports.useContext(Dy);/**
 * @remix-run/router v1.23.0
 *
 * Copyright (c) Remix Software Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE.md file in the root directory of this source tree.
 *
 * @license MIT
 */function _i(){return _i=Object.assign?Object.assign.bind():function(e){for(var t=1;t<arguments.length;t++){var n=arguments[t];for(var r in n)Object.prototype.hasOwnProperty.call(n,r)&&(e[r]=n[r])}return e},_i.apply(this,arguments)}var Fn;(function(e){e.Pop="POP",e.Push="PUSH",e.Replace="REPLACE"})(Fn||(Fn={}));const Dp="popstate";function Db(e){e===void 0&&(e={});function t(r,o){let{pathname:i,search:s,hash:a}=r.location;return Fu("",{pathname:i,search:s,hash:a},o.state&&o.state.usr||null,o.state&&o.state.key||"default")}function n(r,o){return typeof o=="string"?o:Ry(o)}return Rb(t,n,null,e)}function Be(e,t){if(e===!1||e===null||typeof e=="undefined")throw new Error(t)}function My(e,t){if(!e){typeof console!="undefined"&&console.warn(t);try{throw new Error(t)}catch{}}}function Mb(){return Math.random().toString(36).substr(2,8)}function Mp(e,t){return{usr:e.state,key:e.key,idx:t}}function Fu(e,t,n,r){return n===void 0&&(n=null),_i({pathname:typeof e=="string"?e:e.pathname,search:"",hash:""},typeof t=="string"?$o(t):t,{state:n,key:t&&t.key||r||Mb()})}function Ry(e){let{pathname:t="/",search:n="",hash:r=""}=e;return n&&n!=="?"&&(t+=n.charAt(0)==="?"?n:"?"+n),r&&r!=="#"&&(t+=r.charAt(0)==="#"?r:"#"+r),t}function $o(e){let t={};if(e){let n=e.indexOf("#");n>=0&&(t.hash=e.substr(n),e=e.substr(0,n));let r=e.indexOf("?");r>=0&&(t.search=e.substr(r),e=e.substr(0,r)),e&&(t.pathname=e)}return t}function Rb(e,t,n,r){r===void 0&&(r={});let{window:o=document.defaultView,v5Compat:i=!1}=r,s=o.history,a=Fn.Pop,l=null,c=u();c==null&&(c=0,s.replaceState(_i({},s.state,{idx:c}),""));function u(){return(s.state||{idx:null}).idx}function d(){a=Fn.Pop;let b=u(),g=b==null?null:b-c;c=b,l&&l({action:a,location:x.location,delta:g})}function p(b,g){a=Fn.Push;let h=Fu(x.location,b,g);n&&n(h,b),c=u()+1;let m=Mp(h,c),S=x.createHref(h);try{s.pushState(m,"",S)}catch(E){if(E instanceof DOMException&&E.name==="DataCloneError")throw E;o.location.assign(S)}i&&l&&l({action:a,location:x.location,delta:1})}function y(b,g){a=Fn.Replace;let h=Fu(x.location,b,g);n&&n(h,b),c=u();let m=Mp(h,c),S=x.createHref(h);s.replaceState(m,"",S),i&&l&&l({action:a,location:x.location,delta:0})}function w(b){let g=o.location.origin!=="null"?o.location.origin:o.location.href,h=typeof b=="string"?b:Ry(b);return h=h.replace(/ $/,"%20"),Be(g,"No window.location.(origin|href) available to create URL for href: "+h),new URL(h,g)}let x={get action(){return a},get location(){return e(o,s)},listen(b){if(l)throw new Error("A history only accepts one active listener");return o.addEventListener(Dp,d),l=b,()=>{o.removeEventListener(Dp,d),l=null}},createHref(b){return t(o,b)},createURL:w,encodeLocation(b){let g=w(b);return{pathname:g.pathname,search:g.search,hash:g.hash}},push:p,replace:y,go(b){return s.go(b)}};return x}var Rp;(function(e){e.data="data",e.deferred="deferred",e.redirect="redirect",e.error="error"})(Rp||(Rp={}));function $b(e,t,n){return n===void 0&&(n="/"),Lb(e,t,n,!1)}function Lb(e,t,n,r){let o=typeof t=="string"?$o(t):t,i=Ny(o.pathname||"/",n);if(i==null)return null;let s=$y(e);Nb(s);let a=null;for(let l=0;a==null&&l<s.length;++l){let c=Kb(i);a=Wb(s[l],c,r)}return a}function $y(e,t,n,r){t===void 0&&(t=[]),n===void 0&&(n=[]),r===void 0&&(r="");let o=(i,s,a)=>{let l={relativePath:a===void 0?i.path||"":a,caseSensitive:i.caseSensitive===!0,childrenIndex:s,route:i};l.relativePath.startsWith("/")&&(Be(l.relativePath.startsWith(r),'Absolute route path "'+l.relativePath+'" nested under path '+('"'+r+'" is not valid. An absolute child route path ')+"must start with the combined path of all its parent routes."),l.relativePath=l.relativePath.slice(r.length));let c=Sr([r,l.relativePath]),u=n.concat(l);i.children&&i.children.length>0&&(Be(i.index!==!0,"Index routes must not have child routes. Please remove "+('all child routes from route path "'+c+'".')),$y(i.children,t,u,c)),!(i.path==null&&!i.index)&&t.push({path:c,score:Ub(c,i.index),routesMeta:u})};return e.forEach((i,s)=>{var a;if(i.path===""||!((a=i.path)!=null&&a.includes("?")))o(i,s);else for(let l of Ly(i.path))o(i,s,l)}),t}function Ly(e){let t=e.split("/");if(t.length===0)return[];let[n,...r]=t,o=n.endsWith("?"),i=n.replace(/\?$/,"");if(r.length===0)return o?[i,""]:[i];let s=Ly(r.join("/")),a=[];return a.push(...s.map(l=>l===""?i:[i,l].join("/"))),o&&a.push(...s),a.map(l=>e.startsWith("/")&&l===""?"/":l)}function Nb(e){e.sort((t,n)=>t.score!==n.score?n.score-t.score:Hb(t.routesMeta.map(r=>r.childrenIndex),n.routesMeta.map(r=>r.childrenIndex)))}const _b=/^:[\w-]+$/,Fb=3,zb=2,Vb=1,jb=10,Bb=-2,$p=e=>e==="*";function Ub(e,t){let n=e.split("/"),r=n.length;return n.some($p)&&(r+=Bb),t&&(r+=zb),n.filter(o=>!$p(o)).reduce((o,i)=>o+(_b.test(i)?Fb:i===""?Vb:jb),r)}function Hb(e,t){return e.length===t.length&&e.slice(0,-1).every((r,o)=>r===t[o])?e[e.length-1]-t[t.length-1]:0}function Wb(e,t,n){n===void 0&&(n=!1);let{routesMeta:r}=e,o={},i="/",s=[];for(let a=0;a<r.length;++a){let l=r[a],c=a===r.length-1,u=i==="/"?t:t.slice(i.length)||"/",d=Lp({path:l.relativePath,caseSensitive:l.caseSensitive,end:c},u),p=l.route;if(!d&&c&&n&&!r[r.length-1].route.index&&(d=Lp({path:l.relativePath,caseSensitive:l.caseSensitive,end:!1},u)),!d)return null;Object.assign(o,d.params),s.push({params:o,pathname:Sr([i,d.pathname]),pathnameBase:qb(Sr([i,d.pathnameBase])),route:p}),d.pathnameBase!=="/"&&(i=Sr([i,d.pathnameBase]))}return s}function Lp(e,t){typeof e=="string"&&(e={path:e,caseSensitive:!1,end:!0});let[n,r]=Gb(e.path,e.caseSensitive,e.end),o=t.match(n);if(!o)return null;let i=o[0],s=i.replace(/(.)\/+$/,"$1"),a=o.slice(1);return{params:r.reduce((c,u,d)=>{let{paramName:p,isOptional:y}=u;if(p==="*"){let x=a[d]||"";s=i.slice(0,i.length-x.length).replace(/(.)\/+$/,"$1")}const w=a[d];return y&&!w?c[p]=void 0:c[p]=(w||"").replace(/%2F/g,"/"),c},{}),pathname:i,pathnameBase:s,pattern:e}}function Gb(e,t,n){t===void 0&&(t=!1),n===void 0&&(n=!0),My(e==="*"||!e.endsWith("*")||e.endsWith("/*"),'Route path "'+e+'" will be treated as if it were '+('"'+e.replace(/\*$/,"/*")+'" because the `*` character must ')+"always follow a `/` in the pattern. To get rid of this warning, "+('please change the route path to "'+e.replace(/\*$/,"/*")+'".'));let r=[],o="^"+e.replace(/\/*\*?$/,"").replace(/^\/*/,"/").replace(/[\\.*+^${}|()[\]]/g,"\\$&").replace(/\/:([\w-]+)(\?)?/g,(s,a,l)=>(r.push({paramName:a,isOptional:l!=null}),l?"/?([^\\/]+)?":"/([^\\/]+)"));return e.endsWith("*")?(r.push({paramName:"*"}),o+=e==="*"||e==="/*"?"(.*)$":"(?:\\/(.+)|\\/*)$"):n?o+="\\/*$":e!==""&&e!=="/"&&(o+="(?:(?=\\/|$))"),[new RegExp(o,t?void 0:"i"),r]}function Kb(e){try{return e.split("/").map(t=>decodeURIComponent(t).replace(/\//g,"%2F")).join("/")}catch(t){return My(!1,'The URL path "'+e+'" could not be decoded because it is is a malformed URL segment. This is probably due to a bad percent '+("encoding ("+t+").")),e}}function Ny(e,t){if(t==="/")return e;if(!e.toLowerCase().startsWith(t.toLowerCase()))return null;let n=t.endsWith("/")?t.length-1:t.length,r=e.charAt(n);return r&&r!=="/"?null:e.slice(n)||"/"}function Yb(e,t){t===void 0&&(t="/");let{pathname:n,search:r="",hash:o=""}=typeof e=="string"?$o(e):e;return{pathname:n?n.startsWith("/")?n:Qb(n,t):t,search:Zb(r),hash:Jb(o)}}function Qb(e,t){let n=t.replace(/\/+$/,"").split("/");return e.split("/").forEach(o=>{o===".."?n.length>1&&n.pop():o!=="."&&n.push(o)}),n.length>1?n.join("/"):"/"}function oc(e,t,n,r){return"Cannot include a '"+e+"' character in a manually specified "+("`to."+t+"` field ["+JSON.stringify(r)+"].  Please separate it out to the ")+("`to."+n+"` field. Alternatively you may provide the full path as ")+'a string in <Link to="..."> and the router will parse it for you.'}function Xb(e){return e.filter((t,n)=>n===0||t.route.path&&t.route.path.length>0)}function _y(e,t){let n=Xb(e);return t?n.map((r,o)=>o===n.length-1?r.pathname:r.pathnameBase):n.map(r=>r.pathnameBase)}function Fy(e,t,n,r){r===void 0&&(r=!1);let o;typeof e=="string"?o=$o(e):(o=_i({},e),Be(!o.pathname||!o.pathname.includes("?"),oc("?","pathname","search",o)),Be(!o.pathname||!o.pathname.includes("#"),oc("#","pathname","hash",o)),Be(!o.search||!o.search.includes("#"),oc("#","search","hash",o)));let i=e===""||o.pathname==="",s=i?"/":o.pathname,a;if(s==null)a=n;else{let d=t.length-1;if(!r&&s.startsWith("..")){let p=s.split("/");for(;p[0]==="..";)p.shift(),d-=1;o.pathname=p.join("/")}a=d>=0?t[d]:"/"}let l=Yb(o,a),c=s&&s!=="/"&&s.endsWith("/"),u=(i||s===".")&&n.endsWith("/");return!l.pathname.endsWith("/")&&(c||u)&&(l.pathname+="/"),l}const Sr=e=>e.join("/").replace(/\/\/+/g,"/"),qb=e=>e.replace(/\/+$/,"").replace(/^\/*/,"/"),Zb=e=>!e||e==="?"?"":e.startsWith("?")?e:"?"+e,Jb=e=>!e||e==="#"?"":e.startsWith("#")?e:"#"+e;function e4(e){return e!=null&&typeof e.status=="number"&&typeof e.statusText=="string"&&typeof e.internal=="boolean"&&"data"in e}const t4=["post","put","patch","delete"];[...t4];/**
 * React Router v6.30.1
 *
 * Copyright (c) Remix Software Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE.md file in the root directory of this source tree.
 *
 * @license MIT
 */function Fi(){return Fi=Object.assign?Object.assign.bind():function(e){for(var t=1;t<arguments.length;t++){var n=arguments[t];for(var r in n)Object.prototype.hasOwnProperty.call(n,r)&&(e[r]=n[r])}return e},Fi.apply(this,arguments)}const yf=v.exports.createContext(null),n4=v.exports.createContext(null),Ki=v.exports.createContext(null),al=v.exports.createContext(null),ir=v.exports.createContext({outlet:null,matches:[],isDataRoute:!1}),zy=v.exports.createContext(null);function Yi(){return v.exports.useContext(al)!=null}function ll(){return Yi()||Be(!1),v.exports.useContext(al).location}function Vy(e){v.exports.useContext(Ki).static||v.exports.useLayoutEffect(e)}function cl(){let{isDataRoute:e}=v.exports.useContext(ir);return e?m4():r4()}function r4(){Yi()||Be(!1);let e=v.exports.useContext(yf),{basename:t,future:n,navigator:r}=v.exports.useContext(Ki),{matches:o}=v.exports.useContext(ir),{pathname:i}=ll(),s=JSON.stringify(_y(o,n.v7_relativeSplatPath)),a=v.exports.useRef(!1);return Vy(()=>{a.current=!0}),v.exports.useCallback(function(c,u){if(u===void 0&&(u={}),!a.current)return;if(typeof c=="number"){r.go(c);return}let d=Fy(c,JSON.parse(s),i,u.relative==="path");e==null&&t!=="/"&&(d.pathname=d.pathname==="/"?t:Sr([t,d.pathname])),(u.replace?r.replace:r.push)(d,u.state,u)},[t,r,s,i,e])}function vf(){let{matches:e}=v.exports.useContext(ir),t=e[e.length-1];return t?t.params:{}}function o4(e,t){return i4(e,t)}function i4(e,t,n,r){Yi()||Be(!1);let{navigator:o}=v.exports.useContext(Ki),{matches:i}=v.exports.useContext(ir),s=i[i.length-1],a=s?s.params:{};s&&s.pathname;let l=s?s.pathnameBase:"/";s&&s.route;let c=ll(),u;if(t){var d;let b=typeof t=="string"?$o(t):t;l==="/"||((d=b.pathname)==null?void 0:d.startsWith(l))||Be(!1),u=b}else u=c;let p=u.pathname||"/",y=p;if(l!=="/"){let b=l.replace(/^\//,"").split("/"),g=p.replace(/^\//,"").split("/");y="/"+g.slice(b.length).join("/")}let w=$b(e,{pathname:y}),x=u4(w&&w.map(b=>Object.assign({},b,{params:Object.assign({},a,b.params),pathname:Sr([l,o.encodeLocation?o.encodeLocation(b.pathname).pathname:b.pathname]),pathnameBase:b.pathnameBase==="/"?l:Sr([l,o.encodeLocation?o.encodeLocation(b.pathnameBase).pathname:b.pathnameBase])})),i,n,r);return t&&x?v.exports.createElement(al.Provider,{value:{location:Fi({pathname:"/",search:"",hash:"",state:null,key:"default"},u),navigationType:Fn.Pop}},x):x}function s4(){let e=p4(),t=e4(e)?e.status+" "+e.statusText:e instanceof Error?e.message:JSON.stringify(e),n=e instanceof Error?e.stack:null,o={padding:"0.5rem",backgroundColor:"rgba(200,200,200, 0.5)"},i=null;return v.exports.createElement(v.exports.Fragment,null,v.exports.createElement("h2",null,"Unexpected Application Error!"),v.exports.createElement("h3",{style:{fontStyle:"italic"}},t),n?v.exports.createElement("pre",{style:o},n):null,i)}const a4=v.exports.createElement(s4,null);class l4 extends v.exports.Component{constructor(t){super(t),this.state={location:t.location,revalidation:t.revalidation,error:t.error}}static getDerivedStateFromError(t){return{error:t}}static getDerivedStateFromProps(t,n){return n.location!==t.location||n.revalidation!=="idle"&&t.revalidation==="idle"?{error:t.error,location:t.location,revalidation:t.revalidation}:{error:t.error!==void 0?t.error:n.error,location:n.location,revalidation:t.revalidation||n.revalidation}}componentDidCatch(t,n){console.error("React Router caught the following error during render",t,n)}render(){return this.state.error!==void 0?v.exports.createElement(ir.Provider,{value:this.props.routeContext},v.exports.createElement(zy.Provider,{value:this.state.error,children:this.props.component})):this.props.children}}function c4(e){let{routeContext:t,match:n,children:r}=e,o=v.exports.useContext(yf);return o&&o.static&&o.staticContext&&(n.route.errorElement||n.route.ErrorBoundary)&&(o.staticContext._deepestRenderedBoundaryId=n.route.id),v.exports.createElement(ir.Provider,{value:t},r)}function u4(e,t,n,r){var o;if(t===void 0&&(t=[]),n===void 0&&(n=null),r===void 0&&(r=null),e==null){var i;if(!n)return null;if(n.errors)e=n.matches;else if((i=r)!=null&&i.v7_partialHydration&&t.length===0&&!n.initialized&&n.matches.length>0)e=n.matches;else return null}let s=e,a=(o=n)==null?void 0:o.errors;if(a!=null){let u=s.findIndex(d=>d.route.id&&(a==null?void 0:a[d.route.id])!==void 0);u>=0||Be(!1),s=s.slice(0,Math.min(s.length,u+1))}let l=!1,c=-1;if(n&&r&&r.v7_partialHydration)for(let u=0;u<s.length;u++){let d=s[u];if((d.route.HydrateFallback||d.route.hydrateFallbackElement)&&(c=u),d.route.id){let{loaderData:p,errors:y}=n,w=d.route.loader&&p[d.route.id]===void 0&&(!y||y[d.route.id]===void 0);if(d.route.lazy||w){l=!0,c>=0?s=s.slice(0,c+1):s=[s[0]];break}}}return s.reduceRight((u,d,p)=>{let y,w=!1,x=null,b=null;n&&(y=a&&d.route.id?a[d.route.id]:void 0,x=d.route.errorElement||a4,l&&(c<0&&p===0?(g4("route-fallback",!1),w=!0,b=null):c===p&&(w=!0,b=d.route.hydrateFallbackElement||null)));let g=t.concat(s.slice(0,p+1)),h=()=>{let m;return y?m=x:w?m=b:d.route.Component?m=v.exports.createElement(d.route.Component,null):d.route.element?m=d.route.element:m=u,v.exports.createElement(c4,{match:d,routeContext:{outlet:u,matches:g,isDataRoute:n!=null},children:m})};return n&&(d.route.ErrorBoundary||d.route.errorElement||p===0)?v.exports.createElement(l4,{location:n.location,revalidation:n.revalidation,component:x,error:y,children:h(),routeContext:{outlet:null,matches:g,isDataRoute:!0}}):h()},null)}var jy=function(e){return e.UseBlocker="useBlocker",e.UseRevalidator="useRevalidator",e.UseNavigateStable="useNavigate",e}(jy||{}),ba=function(e){return e.UseBlocker="useBlocker",e.UseLoaderData="useLoaderData",e.UseActionData="useActionData",e.UseRouteError="useRouteError",e.UseNavigation="useNavigation",e.UseRouteLoaderData="useRouteLoaderData",e.UseMatches="useMatches",e.UseRevalidator="useRevalidator",e.UseNavigateStable="useNavigate",e.UseRouteId="useRouteId",e}(ba||{});function d4(e){let t=v.exports.useContext(yf);return t||Be(!1),t}function f4(e){let t=v.exports.useContext(n4);return t||Be(!1),t}function h4(e){let t=v.exports.useContext(ir);return t||Be(!1),t}function By(e){let t=h4(),n=t.matches[t.matches.length-1];return n.route.id||Be(!1),n.route.id}function p4(){var e;let t=v.exports.useContext(zy),n=f4(ba.UseRouteError),r=By(ba.UseRouteError);return t!==void 0?t:(e=n.errors)==null?void 0:e[r]}function m4(){let{router:e}=d4(jy.UseNavigateStable),t=By(ba.UseNavigateStable),n=v.exports.useRef(!1);return Vy(()=>{n.current=!0}),v.exports.useCallback(function(o,i){i===void 0&&(i={}),n.current&&(typeof o=="number"?e.navigate(o):e.navigate(o,Fi({fromRouteId:t},i)))},[e,t])}const Np={};function g4(e,t,n){!t&&!Np[e]&&(Np[e]=!0)}function y4(e,t){e==null||e.v7_startTransition,(e==null?void 0:e.v7_relativeSplatPath)===void 0&&(!t||t.v7_relativeSplatPath),t&&(t.v7_fetcherPersist,t.v7_normalizeFormMethod,t.v7_partialHydration,t.v7_skipActionErrorRevalidation)}const v4="startTransition";md[v4];function x4(e){let{to:t,replace:n,state:r,relative:o}=e;Yi()||Be(!1);let{future:i,static:s}=v.exports.useContext(Ki),{matches:a}=v.exports.useContext(ir),{pathname:l}=ll(),c=cl(),u=Fy(t,_y(a,i.v7_relativeSplatPath),l,o==="path"),d=JSON.stringify(u);return v.exports.useEffect(()=>c(JSON.parse(d),{replace:n,state:r,relative:o}),[c,d,o,n,r]),null}function Xe(e){Be(!1)}function w4(e){let{basename:t="/",children:n=null,location:r,navigationType:o=Fn.Pop,navigator:i,static:s=!1,future:a}=e;Yi()&&Be(!1);let l=t.replace(/^\/*/,"/"),c=v.exports.useMemo(()=>({basename:l,navigator:i,static:s,future:Fi({v7_relativeSplatPath:!1},a)}),[l,a,i,s]);typeof r=="string"&&(r=$o(r));let{pathname:u="/",search:d="",hash:p="",state:y=null,key:w="default"}=r,x=v.exports.useMemo(()=>{let b=Ny(u,l);return b==null?null:{location:{pathname:b,search:d,hash:p,state:y,key:w},navigationType:o}},[l,u,d,p,y,w,o]);return x==null?null:v.exports.createElement(Ki.Provider,{value:c},v.exports.createElement(al.Provider,{children:n,value:x}))}function b4(e){let{children:t,location:n}=e;return o4(zu(t),n)}new Promise(()=>{});function zu(e,t){t===void 0&&(t=[]);let n=[];return v.exports.Children.forEach(e,(r,o)=>{if(!v.exports.isValidElement(r))return;let i=[...t,o];if(r.type===v.exports.Fragment){n.push.apply(n,zu(r.props.children,i));return}r.type!==Xe&&Be(!1),!r.props.index||!r.props.children||Be(!1);let s={id:r.props.id||i.join("-"),caseSensitive:r.props.caseSensitive,element:r.props.element,Component:r.props.Component,index:r.props.index,path:r.props.path,loader:r.props.loader,action:r.props.action,errorElement:r.props.errorElement,ErrorBoundary:r.props.ErrorBoundary,hasErrorBoundary:r.props.ErrorBoundary!=null||r.props.errorElement!=null,shouldRevalidate:r.props.shouldRevalidate,handle:r.props.handle,lazy:r.props.lazy};r.props.children&&(s.children=zu(r.props.children,i)),n.push(s)}),n}/**
 * React Router DOM v6.30.1
 *
 * Copyright (c) Remix Software Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE.md file in the root directory of this source tree.
 *
 * @license MIT
 */const C4="6";try{window.__reactRouterVersion=C4}catch{}const S4="startTransition",_p=md[S4],k4="flushSync";kw[k4];const P4="useId";md[P4];function T4(e){let{basename:t,children:n,future:r,window:o}=e,i=v.exports.useRef();i.current==null&&(i.current=Db({window:o,v5Compat:!0}));let s=i.current,[a,l]=v.exports.useState({action:s.action,location:s.location}),{v7_startTransition:c}=r||{},u=v.exports.useCallback(d=>{c&&_p?_p(()=>l(d)):l(d)},[l,c]);return v.exports.useLayoutEffect(()=>s.listen(u),[s,u]),v.exports.useEffect(()=>y4(r),[r]),v.exports.createElement(w4,{basename:t,children:n,location:a.location,navigationType:a.action,navigator:s,future:r})}var Fp;(function(e){e.UseScrollRestoration="useScrollRestoration",e.UseSubmit="useSubmit",e.UseSubmitFetcher="useSubmitFetcher",e.UseFetcher="useFetcher",e.useViewTransitionState="useViewTransitionState"})(Fp||(Fp={}));var zp;(function(e){e.UseFetcher="useFetcher",e.UseFetchers="useFetchers",e.UseScrollRestoration="useScrollRestoration"})(zp||(zp={}));const Uy=v.exports.createContext({transformPagePoint:e=>e,isStatic:!1,reducedMotion:"never"}),ul=v.exports.createContext({}),dl=v.exports.createContext(null),fl=typeof document!="undefined",xf=fl?v.exports.useLayoutEffect:v.exports.useEffect,Hy=v.exports.createContext({strict:!1}),wf=e=>e.replace(/([a-z])([A-Z])/g,"$1-$2").toLowerCase(),E4="framerAppearId",Wy="data-"+wf(E4);function I4(e,t,n,r){const{visualElement:o}=v.exports.useContext(ul),i=v.exports.useContext(Hy),s=v.exports.useContext(dl),a=v.exports.useContext(Uy).reducedMotion,l=v.exports.useRef();r=r||i.renderer,!l.current&&r&&(l.current=r(e,{visualState:t,parent:o,props:n,presenceContext:s,blockInitialAnimation:s?s.initial===!1:!1,reducedMotionConfig:a}));const c=l.current;v.exports.useInsertionEffect(()=>{c&&c.update(n,s)});const u=v.exports.useRef(Boolean(n[Wy]&&!window.HandoffComplete));return xf(()=>{!c||(c.render(),u.current&&c.animationState&&c.animationState.animateChanges())}),v.exports.useEffect(()=>{!c||(c.updateFeatures(),!u.current&&c.animationState&&c.animationState.animateChanges(),u.current&&(u.current=!1,window.HandoffComplete=!0))}),c}function so(e){return e&&typeof e=="object"&&Object.prototype.hasOwnProperty.call(e,"current")}function O4(e,t,n){return v.exports.useCallback(r=>{r&&e.mount&&e.mount(r),t&&(r?t.mount(r):t.unmount()),n&&(typeof n=="function"?n(r):so(n)&&(n.current=r))},[t])}function zi(e){return typeof e=="string"||Array.isArray(e)}function hl(e){return e!==null&&typeof e=="object"&&typeof e.start=="function"}const bf=["animate","whileInView","whileFocus","whileHover","whileTap","whileDrag","exit"],Cf=["initial",...bf];function pl(e){return hl(e.animate)||Cf.some(t=>zi(e[t]))}function Gy(e){return Boolean(pl(e)||e.variants)}function A4(e,t){if(pl(e)){const{initial:n,animate:r}=e;return{initial:n===!1||zi(n)?n:void 0,animate:zi(r)?r:void 0}}return e.inherit!==!1?t:{}}function D4(e){const{initial:t,animate:n}=A4(e,v.exports.useContext(ul));return v.exports.useMemo(()=>({initial:t,animate:n}),[Vp(t),Vp(n)])}function Vp(e){return Array.isArray(e)?e.join(" "):e}const jp={animation:["animate","variants","whileHover","whileTap","exit","whileInView","whileFocus","whileDrag"],exit:["exit"],drag:["drag","dragControls"],focus:["whileFocus"],hover:["whileHover","onHoverStart","onHoverEnd"],tap:["whileTap","onTap","onTapStart","onTapCancel"],pan:["onPan","onPanStart","onPanSessionStart","onPanEnd"],inView:["whileInView","onViewportEnter","onViewportLeave"],layout:["layout","layoutId"]},Vi={};for(const e in jp)Vi[e]={isEnabled:t=>jp[e].some(n=>!!t[n])};function M4(e){for(const t in e)Vi[t]={...Vi[t],...e[t]}}const Sf=v.exports.createContext({}),Ky=v.exports.createContext({}),R4=Symbol.for("motionComponentSymbol");function $4({preloadedFeatures:e,createVisualElement:t,useRender:n,useVisualState:r,Component:o}){e&&M4(e);function i(a,l){let c;const u={...v.exports.useContext(Uy),...a,layoutId:L4(a)},{isStatic:d}=u,p=D4(a),y=r(a,d);if(!d&&fl){p.visualElement=I4(o,y,u,t);const w=v.exports.useContext(Ky),x=v.exports.useContext(Hy).strict;p.visualElement&&(c=p.visualElement.loadFeatures(u,x,e,w))}return v.exports.createElement(ul.Provider,{value:p},c&&p.visualElement?v.exports.createElement(c,{visualElement:p.visualElement,...u}):null,n(o,a,O4(y,p.visualElement,l),y,d,p.visualElement))}const s=v.exports.forwardRef(i);return s[R4]=o,s}function L4({layoutId:e}){const t=v.exports.useContext(Sf).id;return t&&e!==void 0?t+"-"+e:e}function N4(e){function t(r,o={}){return $4(e(r,o))}if(typeof Proxy=="undefined")return t;const n=new Map;return new Proxy(t,{get:(r,o)=>(n.has(o)||n.set(o,t(o)),n.get(o))})}const _4=["animate","circle","defs","desc","ellipse","g","image","line","filter","marker","mask","metadata","path","pattern","polygon","polyline","rect","stop","switch","symbol","svg","text","tspan","use","view"];function kf(e){return typeof e!="string"||e.includes("-")?!1:!!(_4.indexOf(e)>-1||/[A-Z]/.test(e))}const Ca={};function F4(e){Object.assign(Ca,e)}const Qi=["transformPerspective","x","y","z","translateX","translateY","translateZ","scale","scaleX","scaleY","rotate","rotateX","rotateY","rotateZ","skew","skewX","skewY"],$r=new Set(Qi);function Yy(e,{layout:t,layoutId:n}){return $r.has(e)||e.startsWith("origin")||(t||n!==void 0)&&(!!Ca[e]||e==="opacity")}const vt=e=>Boolean(e&&e.getVelocity),z4={x:"translateX",y:"translateY",z:"translateZ",transformPerspective:"perspective"},V4=Qi.length;function j4(e,{enableHardwareAcceleration:t=!0,allowTransformNone:n=!0},r,o){let i="";for(let s=0;s<V4;s++){const a=Qi[s];e[a]!==void 0&&(i+=`${z4[a]||a}(${e[a]}) `)}return t&&!e.z&&(i+="translateZ(0)"),i=i.trim(),o?i=o(e,r?"":i):n&&r&&(i="none"),i}const Qy=e=>t=>typeof t=="string"&&t.startsWith(e),Xy=Qy("--"),Vu=Qy("var(--"),B4=/var\s*\(\s*--[\w-]+(\s*,\s*(?:(?:[^)(]|\((?:[^)(]+|\([^)(]*\))*\))*)+)?\s*\)/g,U4=(e,t)=>t&&typeof e=="number"?t.transform(e):e,er=(e,t,n)=>Math.min(Math.max(n,e),t),Lr={test:e=>typeof e=="number",parse:parseFloat,transform:e=>e},hi={...Lr,transform:e=>er(0,1,e)},bs={...Lr,default:1},pi=e=>Math.round(e*1e5)/1e5,ml=/(-)?([\d]*\.?[\d])+/g,qy=/(#[0-9a-f]{3,8}|(rgb|hsl)a?\((-?[\d\.]+%?[,\s]+){2}(-?[\d\.]+%?)\s*[\,\/]?\s*[\d\.]*%?\))/gi,H4=/^(#[0-9a-f]{3,8}|(rgb|hsl)a?\((-?[\d\.]+%?[,\s]+){2}(-?[\d\.]+%?)\s*[\,\/]?\s*[\d\.]*%?\))$/i;function Xi(e){return typeof e=="string"}const qi=e=>({test:t=>Xi(t)&&t.endsWith(e)&&t.split(" ").length===1,parse:parseFloat,transform:t=>`${t}${e}`}),En=qi("deg"),an=qi("%"),ne=qi("px"),W4=qi("vh"),G4=qi("vw"),Bp={...an,parse:e=>an.parse(e)/100,transform:e=>an.transform(e*100)},Up={...Lr,transform:Math.round},Zy={borderWidth:ne,borderTopWidth:ne,borderRightWidth:ne,borderBottomWidth:ne,borderLeftWidth:ne,borderRadius:ne,radius:ne,borderTopLeftRadius:ne,borderTopRightRadius:ne,borderBottomRightRadius:ne,borderBottomLeftRadius:ne,width:ne,maxWidth:ne,height:ne,maxHeight:ne,size:ne,top:ne,right:ne,bottom:ne,left:ne,padding:ne,paddingTop:ne,paddingRight:ne,paddingBottom:ne,paddingLeft:ne,margin:ne,marginTop:ne,marginRight:ne,marginBottom:ne,marginLeft:ne,rotate:En,rotateX:En,rotateY:En,rotateZ:En,scale:bs,scaleX:bs,scaleY:bs,scaleZ:bs,skew:En,skewX:En,skewY:En,distance:ne,translateX:ne,translateY:ne,translateZ:ne,x:ne,y:ne,z:ne,perspective:ne,transformPerspective:ne,opacity:hi,originX:Bp,originY:Bp,originZ:ne,zIndex:Up,fillOpacity:hi,strokeOpacity:hi,numOctaves:Up};function Pf(e,t,n,r){const{style:o,vars:i,transform:s,transformOrigin:a}=e;let l=!1,c=!1,u=!0;for(const d in t){const p=t[d];if(Xy(d)){i[d]=p;continue}const y=Zy[d],w=U4(p,y);if($r.has(d)){if(l=!0,s[d]=w,!u)continue;p!==(y.default||0)&&(u=!1)}else d.startsWith("origin")?(c=!0,a[d]=w):o[d]=w}if(t.transform||(l||r?o.transform=j4(e.transform,n,u,r):o.transform&&(o.transform="none")),c){const{originX:d="50%",originY:p="50%",originZ:y=0}=a;o.transformOrigin=`${d} ${p} ${y}`}}const Tf=()=>({style:{},transform:{},transformOrigin:{},vars:{}});function Jy(e,t,n){for(const r in t)!vt(t[r])&&!Yy(r,n)&&(e[r]=t[r])}function K4({transformTemplate:e},t,n){return v.exports.useMemo(()=>{const r=Tf();return Pf(r,t,{enableHardwareAcceleration:!n},e),Object.assign({},r.vars,r.style)},[t])}function Y4(e,t,n){const r=e.style||{},o={};return Jy(o,r,e),Object.assign(o,K4(e,t,n)),e.transformValues?e.transformValues(o):o}function Q4(e,t,n){const r={},o=Y4(e,t,n);return e.drag&&e.dragListener!==!1&&(r.draggable=!1,o.userSelect=o.WebkitUserSelect=o.WebkitTouchCallout="none",o.touchAction=e.drag===!0?"none":`pan-${e.drag==="x"?"y":"x"}`),e.tabIndex===void 0&&(e.onTap||e.onTapStart||e.whileTap)&&(r.tabIndex=0),r.style=o,r}const X4=new Set(["animate","exit","variants","initial","style","values","variants","transition","transformTemplate","transformValues","custom","inherit","onBeforeLayoutMeasure","onAnimationStart","onAnimationComplete","onUpdate","onDragStart","onDrag","onDragEnd","onMeasureDragConstraints","onDirectionLock","onDragTransitionEnd","_dragX","_dragY","onHoverStart","onHoverEnd","onViewportEnter","onViewportLeave","globalTapTarget","ignoreStrict","viewport"]);function Sa(e){return e.startsWith("while")||e.startsWith("drag")&&e!=="draggable"||e.startsWith("layout")||e.startsWith("onTap")||e.startsWith("onPan")||e.startsWith("onLayout")||X4.has(e)}let ev=e=>!Sa(e);function q4(e){!e||(ev=t=>t.startsWith("on")?!Sa(t):e(t))}try{q4(require("@emotion/is-prop-valid").default)}catch{}function Z4(e,t,n){const r={};for(const o in e)o==="values"&&typeof e.values=="object"||(ev(o)||n===!0&&Sa(o)||!t&&!Sa(o)||e.draggable&&o.startsWith("onDrag"))&&(r[o]=e[o]);return r}function Hp(e,t,n){return typeof e=="string"?e:ne.transform(t+n*e)}function J4(e,t,n){const r=Hp(t,e.x,e.width),o=Hp(n,e.y,e.height);return`${r} ${o}`}const e3={offset:"stroke-dashoffset",array:"stroke-dasharray"},t3={offset:"strokeDashoffset",array:"strokeDasharray"};function n3(e,t,n=1,r=0,o=!0){e.pathLength=1;const i=o?e3:t3;e[i.offset]=ne.transform(-r);const s=ne.transform(t),a=ne.transform(n);e[i.array]=`${s} ${a}`}function Ef(e,{attrX:t,attrY:n,attrScale:r,originX:o,originY:i,pathLength:s,pathSpacing:a=1,pathOffset:l=0,...c},u,d,p){if(Pf(e,c,u,p),d){e.style.viewBox&&(e.attrs.viewBox=e.style.viewBox);return}e.attrs=e.style,e.style={};const{attrs:y,style:w,dimensions:x}=e;y.transform&&(x&&(w.transform=y.transform),delete y.transform),x&&(o!==void 0||i!==void 0||w.transform)&&(w.transformOrigin=J4(x,o!==void 0?o:.5,i!==void 0?i:.5)),t!==void 0&&(y.x=t),n!==void 0&&(y.y=n),r!==void 0&&(y.scale=r),s!==void 0&&n3(y,s,a,l,!1)}const tv=()=>({...Tf(),attrs:{}}),If=e=>typeof e=="string"&&e.toLowerCase()==="svg";function r3(e,t,n,r){const o=v.exports.useMemo(()=>{const i=tv();return Ef(i,t,{enableHardwareAcceleration:!1},If(r),e.transformTemplate),{...i.attrs,style:{...i.style}}},[t]);if(e.style){const i={};Jy(i,e.style,e),o.style={...i,...o.style}}return o}function o3(e=!1){return(n,r,o,{latestValues:i},s)=>{const l=(kf(n)?r3:Q4)(r,i,s,n),u={...Z4(r,typeof n=="string",e),...l,ref:o},{children:d}=r,p=v.exports.useMemo(()=>vt(d)?d.get():d,[d]);return v.exports.createElement(n,{...u,children:p})}}function nv(e,{style:t,vars:n},r,o){Object.assign(e.style,t,o&&o.getProjectionStyles(r));for(const i in n)e.style.setProperty(i,n[i])}const rv=new Set(["baseFrequency","diffuseConstant","kernelMatrix","kernelUnitLength","keySplines","keyTimes","limitingConeAngle","markerHeight","markerWidth","numOctaves","targetX","targetY","surfaceScale","specularConstant","specularExponent","stdDeviation","tableValues","viewBox","gradientTransform","pathLength","startOffset","textLength","lengthAdjust"]);function ov(e,t,n,r){nv(e,t,void 0,r);for(const o in t.attrs)e.setAttribute(rv.has(o)?o:wf(o),t.attrs[o])}function Of(e,t){const{style:n}=e,r={};for(const o in n)(vt(n[o])||t.style&&vt(t.style[o])||Yy(o,e))&&(r[o]=n[o]);return r}function iv(e,t){const n=Of(e,t);for(const r in e)if(vt(e[r])||vt(t[r])){const o=Qi.indexOf(r)!==-1?"attr"+r.charAt(0).toUpperCase()+r.substring(1):r;n[o]=e[r]}return n}function Af(e,t,n,r={},o={}){return typeof t=="function"&&(t=t(n!==void 0?n:e.custom,r,o)),typeof t=="string"&&(t=e.variants&&e.variants[t]),typeof t=="function"&&(t=t(n!==void 0?n:e.custom,r,o)),t}function sv(e){const t=v.exports.useRef(null);return t.current===null&&(t.current=e()),t.current}const ka=e=>Array.isArray(e),i3=e=>Boolean(e&&typeof e=="object"&&e.mix&&e.toValue),s3=e=>ka(e)?e[e.length-1]||0:e;function Bs(e){const t=vt(e)?e.get():e;return i3(t)?t.toValue():t}function a3({scrapeMotionValuesFromProps:e,createRenderState:t,onMount:n},r,o,i){const s={latestValues:l3(r,o,i,e),renderState:t()};return n&&(s.mount=a=>n(r,a,s)),s}const av=e=>(t,n)=>{const r=v.exports.useContext(ul),o=v.exports.useContext(dl),i=()=>a3(e,t,r,o);return n?i():sv(i)};function l3(e,t,n,r){const o={},i=r(e,{});for(const p in i)o[p]=Bs(i[p]);let{initial:s,animate:a}=e;const l=pl(e),c=Gy(e);t&&c&&!l&&e.inherit!==!1&&(s===void 0&&(s=t.initial),a===void 0&&(a=t.animate));let u=n?n.initial===!1:!1;u=u||s===!1;const d=u?a:s;return d&&typeof d!="boolean"&&!hl(d)&&(Array.isArray(d)?d:[d]).forEach(y=>{const w=Af(e,y);if(!w)return;const{transitionEnd:x,transition:b,...g}=w;for(const h in g){let m=g[h];if(Array.isArray(m)){const S=u?m.length-1:0;m=m[S]}m!==null&&(o[h]=m)}for(const h in x)o[h]=x[h]}),o}const _e=e=>e;class Wp{constructor(){this.order=[],this.scheduled=new Set}add(t){if(!this.scheduled.has(t))return this.scheduled.add(t),this.order.push(t),!0}remove(t){const n=this.order.indexOf(t);n!==-1&&(this.order.splice(n,1),this.scheduled.delete(t))}clear(){this.order.length=0,this.scheduled.clear()}}function c3(e){let t=new Wp,n=new Wp,r=0,o=!1,i=!1;const s=new WeakSet,a={schedule:(l,c=!1,u=!1)=>{const d=u&&o,p=d?t:n;return c&&s.add(l),p.add(l)&&d&&o&&(r=t.order.length),l},cancel:l=>{n.remove(l),s.delete(l)},process:l=>{if(o){i=!0;return}if(o=!0,[t,n]=[n,t],n.clear(),r=t.order.length,r)for(let c=0;c<r;c++){const u=t.order[c];u(l),s.has(u)&&(a.schedule(u),e())}o=!1,i&&(i=!1,a.process(l))}};return a}const Cs=["prepare","read","update","preRender","render","postRender"],u3=40;function d3(e,t){let n=!1,r=!0;const o={delta:0,timestamp:0,isProcessing:!1},i=Cs.reduce((d,p)=>(d[p]=c3(()=>n=!0),d),{}),s=d=>i[d].process(o),a=()=>{const d=performance.now();n=!1,o.delta=r?1e3/60:Math.max(Math.min(d-o.timestamp,u3),1),o.timestamp=d,o.isProcessing=!0,Cs.forEach(s),o.isProcessing=!1,n&&t&&(r=!1,e(a))},l=()=>{n=!0,r=!0,o.isProcessing||e(a)};return{schedule:Cs.reduce((d,p)=>{const y=i[p];return d[p]=(w,x=!1,b=!1)=>(n||l(),y.schedule(w,x,b)),d},{}),cancel:d=>Cs.forEach(p=>i[p].cancel(d)),state:o,steps:i}}const{schedule:Se,cancel:Sn,state:nt,steps:ic}=d3(typeof requestAnimationFrame!="undefined"?requestAnimationFrame:_e,!0),f3={useVisualState:av({scrapeMotionValuesFromProps:iv,createRenderState:tv,onMount:(e,t,{renderState:n,latestValues:r})=>{Se.read(()=>{try{n.dimensions=typeof t.getBBox=="function"?t.getBBox():t.getBoundingClientRect()}catch{n.dimensions={x:0,y:0,width:0,height:0}}}),Se.render(()=>{Ef(n,r,{enableHardwareAcceleration:!1},If(t.tagName),e.transformTemplate),ov(t,n)})}})},h3={useVisualState:av({scrapeMotionValuesFromProps:Of,createRenderState:Tf})};function p3(e,{forwardMotionProps:t=!1},n,r){return{...kf(e)?f3:h3,preloadedFeatures:n,useRender:o3(t),createVisualElement:r,Component:e}}function mn(e,t,n,r={passive:!0}){return e.addEventListener(t,n,r),()=>e.removeEventListener(t,n)}const lv=e=>e.pointerType==="mouse"?typeof e.button!="number"||e.button<=0:e.isPrimary!==!1;function gl(e,t="page"){return{point:{x:e[t+"X"],y:e[t+"Y"]}}}const m3=e=>t=>lv(t)&&e(t,gl(t));function yn(e,t,n,r){return mn(e,t,m3(n),r)}const g3=(e,t)=>n=>t(e(n)),Yn=(...e)=>e.reduce(g3);function cv(e){let t=null;return()=>{const n=()=>{t=null};return t===null?(t=e,n):!1}}const Gp=cv("dragHorizontal"),Kp=cv("dragVertical");function uv(e){let t=!1;if(e==="y")t=Kp();else if(e==="x")t=Gp();else{const n=Gp(),r=Kp();n&&r?t=()=>{n(),r()}:(n&&n(),r&&r())}return t}function dv(){const e=uv(!0);return e?(e(),!1):!0}class sr{constructor(t){this.isMounted=!1,this.node=t}update(){}}function Yp(e,t){const n="pointer"+(t?"enter":"leave"),r="onHover"+(t?"Start":"End"),o=(i,s)=>{if(i.pointerType==="touch"||dv())return;const a=e.getProps();e.animationState&&a.whileHover&&e.animationState.setActive("whileHover",t),a[r]&&Se.update(()=>a[r](i,s))};return yn(e.current,n,o,{passive:!e.getProps()[r]})}class y3 extends sr{mount(){this.unmount=Yn(Yp(this.node,!0),Yp(this.node,!1))}unmount(){}}class v3 extends sr{constructor(){super(...arguments),this.isActive=!1}onFocus(){let t=!1;try{t=this.node.current.matches(":focus-visible")}catch{t=!0}!t||!this.node.animationState||(this.node.animationState.setActive("whileFocus",!0),this.isActive=!0)}onBlur(){!this.isActive||!this.node.animationState||(this.node.animationState.setActive("whileFocus",!1),this.isActive=!1)}mount(){this.unmount=Yn(mn(this.node.current,"focus",()=>this.onFocus()),mn(this.node.current,"blur",()=>this.onBlur()))}unmount(){}}const fv=(e,t)=>t?e===t?!0:fv(e,t.parentElement):!1;function sc(e,t){if(!t)return;const n=new PointerEvent("pointer"+e);t(n,gl(n))}class x3 extends sr{constructor(){super(...arguments),this.removeStartListeners=_e,this.removeEndListeners=_e,this.removeAccessibleListeners=_e,this.startPointerPress=(t,n)=>{if(this.isPressing)return;this.removeEndListeners();const r=this.node.getProps(),i=yn(window,"pointerup",(a,l)=>{if(!this.checkPressEnd())return;const{onTap:c,onTapCancel:u,globalTapTarget:d}=this.node.getProps();Se.update(()=>{!d&&!fv(this.node.current,a.target)?u&&u(a,l):c&&c(a,l)})},{passive:!(r.onTap||r.onPointerUp)}),s=yn(window,"pointercancel",(a,l)=>this.cancelPress(a,l),{passive:!(r.onTapCancel||r.onPointerCancel)});this.removeEndListeners=Yn(i,s),this.startPress(t,n)},this.startAccessiblePress=()=>{const t=i=>{if(i.key!=="Enter"||this.isPressing)return;const s=a=>{a.key!=="Enter"||!this.checkPressEnd()||sc("up",(l,c)=>{const{onTap:u}=this.node.getProps();u&&Se.update(()=>u(l,c))})};this.removeEndListeners(),this.removeEndListeners=mn(this.node.current,"keyup",s),sc("down",(a,l)=>{this.startPress(a,l)})},n=mn(this.node.current,"keydown",t),r=()=>{!this.isPressing||sc("cancel",(i,s)=>this.cancelPress(i,s))},o=mn(this.node.current,"blur",r);this.removeAccessibleListeners=Yn(n,o)}}startPress(t,n){this.isPressing=!0;const{onTapStart:r,whileTap:o}=this.node.getProps();o&&this.node.animationState&&this.node.animationState.setActive("whileTap",!0),r&&Se.update(()=>r(t,n))}checkPressEnd(){return this.removeEndListeners(),this.isPressing=!1,this.node.getProps().whileTap&&this.node.animationState&&this.node.animationState.setActive("whileTap",!1),!dv()}cancelPress(t,n){if(!this.checkPressEnd())return;const{onTapCancel:r}=this.node.getProps();r&&Se.update(()=>r(t,n))}mount(){const t=this.node.getProps(),n=yn(t.globalTapTarget?window:this.node.current,"pointerdown",this.startPointerPress,{passive:!(t.onTapStart||t.onPointerStart)}),r=mn(this.node.current,"focus",this.startAccessiblePress);this.removeStartListeners=Yn(n,r)}unmount(){this.removeStartListeners(),this.removeEndListeners(),this.removeAccessibleListeners()}}const ju=new WeakMap,ac=new WeakMap,w3=e=>{const t=ju.get(e.target);t&&t(e)},b3=e=>{e.forEach(w3)};function C3({root:e,...t}){const n=e||document;ac.has(n)||ac.set(n,{});const r=ac.get(n),o=JSON.stringify(t);return r[o]||(r[o]=new IntersectionObserver(b3,{root:e,...t})),r[o]}function S3(e,t,n){const r=C3(t);return ju.set(e,n),r.observe(e),()=>{ju.delete(e),r.unobserve(e)}}const k3={some:0,all:1};class P3 extends sr{constructor(){super(...arguments),this.hasEnteredView=!1,this.isInView=!1}startObserver(){this.unmount();const{viewport:t={}}=this.node.getProps(),{root:n,margin:r,amount:o="some",once:i}=t,s={root:n?n.current:void 0,rootMargin:r,threshold:typeof o=="number"?o:k3[o]},a=l=>{const{isIntersecting:c}=l;if(this.isInView===c||(this.isInView=c,i&&!c&&this.hasEnteredView))return;c&&(this.hasEnteredView=!0),this.node.animationState&&this.node.animationState.setActive("whileInView",c);const{onViewportEnter:u,onViewportLeave:d}=this.node.getProps(),p=c?u:d;p&&p(l)};return S3(this.node.current,s,a)}mount(){this.startObserver()}update(){if(typeof IntersectionObserver=="undefined")return;const{props:t,prevProps:n}=this.node;["amount","margin","root"].some(T3(t,n))&&this.startObserver()}unmount(){}}function T3({viewport:e={}},{viewport:t={}}={}){return n=>e[n]!==t[n]}const E3={inView:{Feature:P3},tap:{Feature:x3},focus:{Feature:v3},hover:{Feature:y3}};function hv(e,t){if(!Array.isArray(t))return!1;const n=t.length;if(n!==e.length)return!1;for(let r=0;r<n;r++)if(t[r]!==e[r])return!1;return!0}function I3(e){const t={};return e.values.forEach((n,r)=>t[r]=n.get()),t}function O3(e){const t={};return e.values.forEach((n,r)=>t[r]=n.getVelocity()),t}function yl(e,t,n){const r=e.getProps();return Af(r,t,n!==void 0?n:r.custom,I3(e),O3(e))}let Df=_e,vl=_e;const Qn=e=>e*1e3,vn=e=>e/1e3,Qp={current:!1},pv=e=>Array.isArray(e)&&typeof e[0]=="number";function mv(e){return Boolean(!e||typeof e=="string"&&gv[e]||pv(e)||Array.isArray(e)&&e.every(mv))}const ti=([e,t,n,r])=>`cubic-bezier(${e}, ${t}, ${n}, ${r})`,gv={linear:"linear",ease:"ease",easeIn:"ease-in",easeOut:"ease-out",easeInOut:"ease-in-out",circIn:ti([0,.65,.55,1]),circOut:ti([.55,0,1,.45]),backIn:ti([.31,.01,.66,-.59]),backOut:ti([.33,1.53,.69,.99])};function yv(e){if(!!e)return pv(e)?ti(e):Array.isArray(e)?e.map(yv):gv[e]}function A3(e,t,n,{delay:r=0,duration:o,repeat:i=0,repeatType:s="loop",ease:a,times:l}={}){const c={[t]:n};l&&(c.offset=l);const u=yv(a);return Array.isArray(u)&&(c.easing=u),e.animate(c,{delay:r,duration:o,easing:Array.isArray(u)?"linear":u,fill:"both",iterations:i+1,direction:s==="reverse"?"alternate":"normal"})}function D3(e,{repeat:t,repeatType:n="loop"}){const r=t&&n!=="loop"&&t%2===1?0:e.length-1;return e[r]}const vv=(e,t,n)=>(((1-3*n+3*t)*e+(3*n-6*t))*e+3*t)*e,M3=1e-7,R3=12;function $3(e,t,n,r,o){let i,s,a=0;do s=t+(n-t)/2,i=vv(s,r,o)-e,i>0?n=s:t=s;while(Math.abs(i)>M3&&++a<R3);return s}function Zi(e,t,n,r){if(e===t&&n===r)return _e;const o=i=>$3(i,0,1,e,n);return i=>i===0||i===1?i:vv(o(i),t,r)}const L3=Zi(.42,0,1,1),N3=Zi(0,0,.58,1),xv=Zi(.42,0,.58,1),_3=e=>Array.isArray(e)&&typeof e[0]!="number",wv=e=>t=>t<=.5?e(2*t)/2:(2-e(2*(1-t)))/2,bv=e=>t=>1-e(1-t),Mf=e=>1-Math.sin(Math.acos(e)),Cv=bv(Mf),F3=wv(Mf),Sv=Zi(.33,1.53,.69,.99),Rf=bv(Sv),z3=wv(Rf),V3=e=>(e*=2)<1?.5*Rf(e):.5*(2-Math.pow(2,-10*(e-1))),j3={linear:_e,easeIn:L3,easeInOut:xv,easeOut:N3,circIn:Mf,circInOut:F3,circOut:Cv,backIn:Rf,backInOut:z3,backOut:Sv,anticipate:V3},Xp=e=>{if(Array.isArray(e)){vl(e.length===4);const[t,n,r,o]=e;return Zi(t,n,r,o)}else if(typeof e=="string")return j3[e];return e},$f=(e,t)=>n=>Boolean(Xi(n)&&H4.test(n)&&n.startsWith(e)||t&&Object.prototype.hasOwnProperty.call(n,t)),kv=(e,t,n)=>r=>{if(!Xi(r))return r;const[o,i,s,a]=r.match(ml);return{[e]:parseFloat(o),[t]:parseFloat(i),[n]:parseFloat(s),alpha:a!==void 0?parseFloat(a):1}},B3=e=>er(0,255,e),lc={...Lr,transform:e=>Math.round(B3(e))},wr={test:$f("rgb","red"),parse:kv("red","green","blue"),transform:({red:e,green:t,blue:n,alpha:r=1})=>"rgba("+lc.transform(e)+", "+lc.transform(t)+", "+lc.transform(n)+", "+pi(hi.transform(r))+")"};function U3(e){let t="",n="",r="",o="";return e.length>5?(t=e.substring(1,3),n=e.substring(3,5),r=e.substring(5,7),o=e.substring(7,9)):(t=e.substring(1,2),n=e.substring(2,3),r=e.substring(3,4),o=e.substring(4,5),t+=t,n+=n,r+=r,o+=o),{red:parseInt(t,16),green:parseInt(n,16),blue:parseInt(r,16),alpha:o?parseInt(o,16)/255:1}}const Bu={test:$f("#"),parse:U3,transform:wr.transform},ao={test:$f("hsl","hue"),parse:kv("hue","saturation","lightness"),transform:({hue:e,saturation:t,lightness:n,alpha:r=1})=>"hsla("+Math.round(e)+", "+an.transform(pi(t))+", "+an.transform(pi(n))+", "+pi(hi.transform(r))+")"},at={test:e=>wr.test(e)||Bu.test(e)||ao.test(e),parse:e=>wr.test(e)?wr.parse(e):ao.test(e)?ao.parse(e):Bu.parse(e),transform:e=>Xi(e)?e:e.hasOwnProperty("red")?wr.transform(e):ao.transform(e)},Re=(e,t,n)=>-n*e+n*t+e;function cc(e,t,n){return n<0&&(n+=1),n>1&&(n-=1),n<1/6?e+(t-e)*6*n:n<1/2?t:n<2/3?e+(t-e)*(2/3-n)*6:e}function H3({hue:e,saturation:t,lightness:n,alpha:r}){e/=360,t/=100,n/=100;let o=0,i=0,s=0;if(!t)o=i=s=n;else{const a=n<.5?n*(1+t):n+t-n*t,l=2*n-a;o=cc(l,a,e+1/3),i=cc(l,a,e),s=cc(l,a,e-1/3)}return{red:Math.round(o*255),green:Math.round(i*255),blue:Math.round(s*255),alpha:r}}const uc=(e,t,n)=>{const r=e*e;return Math.sqrt(Math.max(0,n*(t*t-r)+r))},W3=[Bu,wr,ao],G3=e=>W3.find(t=>t.test(e));function qp(e){const t=G3(e);let n=t.parse(e);return t===ao&&(n=H3(n)),n}const Pv=(e,t)=>{const n=qp(e),r=qp(t),o={...n};return i=>(o.red=uc(n.red,r.red,i),o.green=uc(n.green,r.green,i),o.blue=uc(n.blue,r.blue,i),o.alpha=Re(n.alpha,r.alpha,i),wr.transform(o))};function K3(e){var t,n;return isNaN(e)&&Xi(e)&&(((t=e.match(ml))===null||t===void 0?void 0:t.length)||0)+(((n=e.match(qy))===null||n===void 0?void 0:n.length)||0)>0}const Tv={regex:B4,countKey:"Vars",token:"${v}",parse:_e},Ev={regex:qy,countKey:"Colors",token:"${c}",parse:at.parse},Iv={regex:ml,countKey:"Numbers",token:"${n}",parse:Lr.parse};function dc(e,{regex:t,countKey:n,token:r,parse:o}){const i=e.tokenised.match(t);!i||(e["num"+n]=i.length,e.tokenised=e.tokenised.replace(t,r),e.values.push(...i.map(o)))}function Pa(e){const t=e.toString(),n={value:t,tokenised:t,values:[],numVars:0,numColors:0,numNumbers:0};return n.value.includes("var(--")&&dc(n,Tv),dc(n,Ev),dc(n,Iv),n}function Ov(e){return Pa(e).values}function Av(e){const{values:t,numColors:n,numVars:r,tokenised:o}=Pa(e),i=t.length;return s=>{let a=o;for(let l=0;l<i;l++)l<r?a=a.replace(Tv.token,s[l]):l<r+n?a=a.replace(Ev.token,at.transform(s[l])):a=a.replace(Iv.token,pi(s[l]));return a}}const Y3=e=>typeof e=="number"?0:e;function Q3(e){const t=Ov(e);return Av(e)(t.map(Y3))}const tr={test:K3,parse:Ov,createTransformer:Av,getAnimatableNone:Q3},Dv=(e,t)=>n=>`${n>0?t:e}`;function Mv(e,t){return typeof e=="number"?n=>Re(e,t,n):at.test(e)?Pv(e,t):e.startsWith("var(")?Dv(e,t):$v(e,t)}const Rv=(e,t)=>{const n=[...e],r=n.length,o=e.map((i,s)=>Mv(i,t[s]));return i=>{for(let s=0;s<r;s++)n[s]=o[s](i);return n}},X3=(e,t)=>{const n={...e,...t},r={};for(const o in n)e[o]!==void 0&&t[o]!==void 0&&(r[o]=Mv(e[o],t[o]));return o=>{for(const i in r)n[i]=r[i](o);return n}},$v=(e,t)=>{const n=tr.createTransformer(t),r=Pa(e),o=Pa(t);return r.numVars===o.numVars&&r.numColors===o.numColors&&r.numNumbers>=o.numNumbers?Yn(Rv(r.values,o.values),n):(Df(!0),Dv(e,t))},ji=(e,t,n)=>{const r=t-e;return r===0?1:(n-e)/r},Zp=(e,t)=>n=>Re(e,t,n);function q3(e){return typeof e=="number"?Zp:typeof e=="string"?at.test(e)?Pv:$v:Array.isArray(e)?Rv:typeof e=="object"?X3:Zp}function Z3(e,t,n){const r=[],o=n||q3(e[0]),i=e.length-1;for(let s=0;s<i;s++){let a=o(e[s],e[s+1]);if(t){const l=Array.isArray(t)?t[s]||_e:t;a=Yn(l,a)}r.push(a)}return r}function Lv(e,t,{clamp:n=!0,ease:r,mixer:o}={}){const i=e.length;if(vl(i===t.length),i===1)return()=>t[0];e[0]>e[i-1]&&(e=[...e].reverse(),t=[...t].reverse());const s=Z3(t,r,o),a=s.length,l=c=>{let u=0;if(a>1)for(;u<e.length-2&&!(c<e[u+1]);u++);const d=ji(e[u],e[u+1],c);return s[u](d)};return n?c=>l(er(e[0],e[i-1],c)):l}function J3(e,t){const n=e[e.length-1];for(let r=1;r<=t;r++){const o=ji(0,t,r);e.push(Re(n,1,o))}}function eC(e){const t=[0];return J3(t,e.length-1),t}function tC(e,t){return e.map(n=>n*t)}function nC(e,t){return e.map(()=>t||xv).splice(0,e.length-1)}function Ta({duration:e=300,keyframes:t,times:n,ease:r="easeInOut"}){const o=_3(r)?r.map(Xp):Xp(r),i={done:!1,value:t[0]},s=tC(n&&n.length===t.length?n:eC(t),e),a=Lv(s,t,{ease:Array.isArray(o)?o:nC(t,o)});return{calculatedDuration:e,next:l=>(i.value=a(l),i.done=l>=e,i)}}function Nv(e,t){return t?e*(1e3/t):0}const rC=5;function _v(e,t,n){const r=Math.max(t-rC,0);return Nv(n-e(r),t-r)}const fc=.001,oC=.01,Jp=10,iC=.05,sC=1;function aC({duration:e=800,bounce:t=.25,velocity:n=0,mass:r=1}){let o,i;Df(e<=Qn(Jp));let s=1-t;s=er(iC,sC,s),e=er(oC,Jp,vn(e)),s<1?(o=c=>{const u=c*s,d=u*e,p=u-n,y=Uu(c,s),w=Math.exp(-d);return fc-p/y*w},i=c=>{const d=c*s*e,p=d*n+n,y=Math.pow(s,2)*Math.pow(c,2)*e,w=Math.exp(-d),x=Uu(Math.pow(c,2),s);return(-o(c)+fc>0?-1:1)*((p-y)*w)/x}):(o=c=>{const u=Math.exp(-c*e),d=(c-n)*e+1;return-fc+u*d},i=c=>{const u=Math.exp(-c*e),d=(n-c)*(e*e);return u*d});const a=5/e,l=cC(o,i,a);if(e=Qn(e),isNaN(l))return{stiffness:100,damping:10,duration:e};{const c=Math.pow(l,2)*r;return{stiffness:c,damping:s*2*Math.sqrt(r*c),duration:e}}}const lC=12;function cC(e,t,n){let r=n;for(let o=1;o<lC;o++)r=r-e(r)/t(r);return r}function Uu(e,t){return e*Math.sqrt(1-t*t)}const uC=["duration","bounce"],dC=["stiffness","damping","mass"];function em(e,t){return t.some(n=>e[n]!==void 0)}function fC(e){let t={velocity:0,stiffness:100,damping:10,mass:1,isResolvedFromDuration:!1,...e};if(!em(e,dC)&&em(e,uC)){const n=aC(e);t={...t,...n,mass:1},t.isResolvedFromDuration=!0}return t}function Fv({keyframes:e,restDelta:t,restSpeed:n,...r}){const o=e[0],i=e[e.length-1],s={done:!1,value:o},{stiffness:a,damping:l,mass:c,duration:u,velocity:d,isResolvedFromDuration:p}=fC({...r,velocity:-vn(r.velocity||0)}),y=d||0,w=l/(2*Math.sqrt(a*c)),x=i-o,b=vn(Math.sqrt(a/c)),g=Math.abs(x)<5;n||(n=g?.01:2),t||(t=g?.005:.5);let h;if(w<1){const m=Uu(b,w);h=S=>{const E=Math.exp(-w*b*S);return i-E*((y+w*b*x)/m*Math.sin(m*S)+x*Math.cos(m*S))}}else if(w===1)h=m=>i-Math.exp(-b*m)*(x+(y+b*x)*m);else{const m=b*Math.sqrt(w*w-1);h=S=>{const E=Math.exp(-w*b*S),T=Math.min(m*S,300);return i-E*((y+w*b*x)*Math.sinh(T)+m*x*Math.cosh(T))/m}}return{calculatedDuration:p&&u||null,next:m=>{const S=h(m);if(p)s.done=m>=u;else{let E=y;m!==0&&(w<1?E=_v(h,m,S):E=0);const T=Math.abs(E)<=n,I=Math.abs(i-S)<=t;s.done=T&&I}return s.value=s.done?i:S,s}}}function tm({keyframes:e,velocity:t=0,power:n=.8,timeConstant:r=325,bounceDamping:o=10,bounceStiffness:i=500,modifyTarget:s,min:a,max:l,restDelta:c=.5,restSpeed:u}){const d=e[0],p={done:!1,value:d},y=O=>a!==void 0&&O<a||l!==void 0&&O>l,w=O=>a===void 0?l:l===void 0||Math.abs(a-O)<Math.abs(l-O)?a:l;let x=n*t;const b=d+x,g=s===void 0?b:s(b);g!==b&&(x=g-d);const h=O=>-x*Math.exp(-O/r),m=O=>g+h(O),S=O=>{const L=h(O),_=m(O);p.done=Math.abs(L)<=c,p.value=p.done?g:_};let E,T;const I=O=>{!y(p.value)||(E=O,T=Fv({keyframes:[p.value,w(p.value)],velocity:_v(m,O,p.value),damping:o,stiffness:i,restDelta:c,restSpeed:u}))};return I(0),{calculatedDuration:null,next:O=>{let L=!1;return!T&&E===void 0&&(L=!0,S(O),I(O)),E!==void 0&&O>E?T.next(O-E):(!L&&S(O),p)}}}const hC=e=>{const t=({timestamp:n})=>e(n);return{start:()=>Se.update(t,!0),stop:()=>Sn(t),now:()=>nt.isProcessing?nt.timestamp:performance.now()}},nm=2e4;function rm(e){let t=0;const n=50;let r=e.next(t);for(;!r.done&&t<nm;)t+=n,r=e.next(t);return t>=nm?1/0:t}const pC={decay:tm,inertia:tm,tween:Ta,keyframes:Ta,spring:Fv};function Ea({autoplay:e=!0,delay:t=0,driver:n=hC,keyframes:r,type:o="keyframes",repeat:i=0,repeatDelay:s=0,repeatType:a="loop",onPlay:l,onStop:c,onComplete:u,onUpdate:d,...p}){let y=1,w=!1,x,b;const g=()=>{b=new Promise(W=>{x=W})};g();let h;const m=pC[o]||Ta;let S;m!==Ta&&typeof r[0]!="number"&&(S=Lv([0,100],r,{clamp:!1}),r=[0,100]);const E=m({...p,keyframes:r});let T;a==="mirror"&&(T=m({...p,keyframes:[...r].reverse(),velocity:-(p.velocity||0)}));let I="idle",O=null,L=null,_=null;E.calculatedDuration===null&&i&&(E.calculatedDuration=rm(E));const{calculatedDuration:re}=E;let J=1/0,se=1/0;re!==null&&(J=re+s,se=J*(i+1)-s);let j=0;const Y=W=>{if(L===null)return;y>0&&(L=Math.min(L,W)),y<0&&(L=Math.min(W-se/y,L)),O!==null?j=O:j=Math.round(W-L)*y;const R=j-t*(y>=0?1:-1),F=y>=0?R<0:R>se;j=Math.max(R,0),I==="finished"&&O===null&&(j=se);let V=j,X=E;if(i){const ue=Math.min(j,se)/J;let te=Math.floor(ue),le=ue%1;!le&&ue>=1&&(le=1),le===1&&te--,te=Math.min(te,i+1),Boolean(te%2)&&(a==="reverse"?(le=1-le,s&&(le-=s/J)):a==="mirror"&&(X=T)),V=er(0,1,le)*J}const k=F?{done:!1,value:r[0]}:X.next(V);S&&(k.value=S(k.value));let{done:U}=k;!F&&re!==null&&(U=y>=0?j>=se:j<=0);const M=O===null&&(I==="finished"||I==="running"&&U);return d&&d(k.value),M&&$(),k},z=()=>{h&&h.stop(),h=void 0},ee=()=>{I="idle",z(),x(),g(),L=_=null},$=()=>{I="finished",u&&u(),z(),x()},B=()=>{if(w)return;h||(h=n(Y));const W=h.now();l&&l(),O!==null?L=W-O:(!L||I==="finished")&&(L=W),I==="finished"&&g(),_=L,O=null,I="running",h.start()};e&&B();const G={then(W,R){return b.then(W,R)},get time(){return vn(j)},set time(W){W=Qn(W),j=W,O!==null||!h||y===0?O=W:L=h.now()-W/y},get duration(){const W=E.calculatedDuration===null?rm(E):E.calculatedDuration;return vn(W)},get speed(){return y},set speed(W){W===y||!h||(y=W,G.time=vn(j))},get state(){return I},play:B,pause:()=>{I="paused",O=j},stop:()=>{w=!0,I!=="idle"&&(I="idle",c&&c(),ee())},cancel:()=>{_!==null&&Y(_),ee()},complete:()=>{I="finished"},sample:W=>(L=0,Y(W))};return G}function mC(e){let t;return()=>(t===void 0&&(t=e()),t)}const gC=mC(()=>Object.hasOwnProperty.call(Element.prototype,"animate")),yC=new Set(["opacity","clipPath","filter","transform","backgroundColor"]),Ss=10,vC=2e4,xC=(e,t)=>t.type==="spring"||e==="backgroundColor"||!mv(t.ease);function wC(e,t,{onUpdate:n,onComplete:r,...o}){if(!(gC()&&yC.has(t)&&!o.repeatDelay&&o.repeatType!=="mirror"&&o.damping!==0&&o.type!=="inertia"))return!1;let s=!1,a,l,c=!1;const u=()=>{l=new Promise(m=>{a=m})};u();let{keyframes:d,duration:p=300,ease:y,times:w}=o;if(xC(t,o)){const m=Ea({...o,repeat:0,delay:0});let S={done:!1,value:d[0]};const E=[];let T=0;for(;!S.done&&T<vC;)S=m.sample(T),E.push(S.value),T+=Ss;w=void 0,d=E,p=T-Ss,y="linear"}const x=A3(e.owner.current,t,d,{...o,duration:p,ease:y,times:w}),b=()=>{c=!1,x.cancel()},g=()=>{c=!0,Se.update(b),a(),u()};return x.onfinish=()=>{c||(e.set(D3(d,o)),r&&r(),g())},{then(m,S){return l.then(m,S)},attachTimeline(m){return x.timeline=m,x.onfinish=null,_e},get time(){return vn(x.currentTime||0)},set time(m){x.currentTime=Qn(m)},get speed(){return x.playbackRate},set speed(m){x.playbackRate=m},get duration(){return vn(p)},play:()=>{s||(x.play(),Sn(b))},pause:()=>x.pause(),stop:()=>{if(s=!0,x.playState==="idle")return;const{currentTime:m}=x;if(m){const S=Ea({...o,autoplay:!1});e.setWithVelocity(S.sample(m-Ss).value,S.sample(m).value,Ss)}g()},complete:()=>{c||x.finish()},cancel:g}}function bC({keyframes:e,delay:t,onUpdate:n,onComplete:r}){const o=()=>(n&&n(e[e.length-1]),r&&r(),{time:0,speed:1,duration:0,play:_e,pause:_e,stop:_e,then:i=>(i(),Promise.resolve()),cancel:_e,complete:_e});return t?Ea({keyframes:[0,1],duration:0,delay:t,onComplete:o}):o()}const CC={type:"spring",stiffness:500,damping:25,restSpeed:10},SC=e=>({type:"spring",stiffness:550,damping:e===0?2*Math.sqrt(550):30,restSpeed:10}),kC={type:"keyframes",duration:.8},PC={type:"keyframes",ease:[.25,.1,.35,1],duration:.3},TC=(e,{keyframes:t})=>t.length>2?kC:$r.has(e)?e.startsWith("scale")?SC(t[1]):CC:PC,Hu=(e,t)=>e==="zIndex"?!1:!!(typeof t=="number"||Array.isArray(t)||typeof t=="string"&&(tr.test(t)||t==="0")&&!t.startsWith("url(")),EC=new Set(["brightness","contrast","saturate","opacity"]);function IC(e){const[t,n]=e.slice(0,-1).split("(");if(t==="drop-shadow")return e;const[r]=n.match(ml)||[];if(!r)return e;const o=n.replace(r,"");let i=EC.has(t)?1:0;return r!==n&&(i*=100),t+"("+i+o+")"}const OC=/([a-z-]*)\(.*?\)/g,Wu={...tr,getAnimatableNone:e=>{const t=e.match(OC);return t?t.map(IC).join(" "):e}},AC={...Zy,color:at,backgroundColor:at,outlineColor:at,fill:at,stroke:at,borderColor:at,borderTopColor:at,borderRightColor:at,borderBottomColor:at,borderLeftColor:at,filter:Wu,WebkitFilter:Wu},Lf=e=>AC[e];function zv(e,t){let n=Lf(e);return n!==Wu&&(n=tr),n.getAnimatableNone?n.getAnimatableNone(t):void 0}const Vv=e=>/^0[^.\s]+$/.test(e);function DC(e){if(typeof e=="number")return e===0;if(e!==null)return e==="none"||e==="0"||Vv(e)}function MC(e,t,n,r){const o=Hu(t,n);let i;Array.isArray(n)?i=[...n]:i=[null,n];const s=r.from!==void 0?r.from:e.get();let a;const l=[];for(let c=0;c<i.length;c++)i[c]===null&&(i[c]=c===0?s:i[c-1]),DC(i[c])&&l.push(c),typeof i[c]=="string"&&i[c]!=="none"&&i[c]!=="0"&&(a=i[c]);if(o&&l.length&&a)for(let c=0;c<l.length;c++){const u=l[c];i[u]=zv(t,a)}return i}function RC({when:e,delay:t,delayChildren:n,staggerChildren:r,staggerDirection:o,repeat:i,repeatType:s,repeatDelay:a,from:l,elapsed:c,...u}){return!!Object.keys(u).length}function Nf(e,t){return e[t]||e.default||e}const $C={skipAnimations:!1},_f=(e,t,n,r={})=>o=>{const i=Nf(r,e)||{},s=i.delay||r.delay||0;let{elapsed:a=0}=r;a=a-Qn(s);const l=MC(t,e,n,i),c=l[0],u=l[l.length-1],d=Hu(e,c),p=Hu(e,u);Df(d===p);let y={keyframes:l,velocity:t.getVelocity(),ease:"easeOut",...i,delay:-a,onUpdate:w=>{t.set(w),i.onUpdate&&i.onUpdate(w)},onComplete:()=>{o(),i.onComplete&&i.onComplete()}};if(RC(i)||(y={...y,...TC(e,y)}),y.duration&&(y.duration=Qn(y.duration)),y.repeatDelay&&(y.repeatDelay=Qn(y.repeatDelay)),!d||!p||Qp.current||i.type===!1||$C.skipAnimations)return bC(Qp.current?{...y,delay:0}:y);if(!r.isHandoff&&t.owner&&t.owner.current instanceof HTMLElement&&!t.owner.getProps().onUpdate){const w=wC(t,e,y);if(w)return w}return Ea(y)};function Ia(e){return Boolean(vt(e)&&e.add)}const jv=e=>/^\-?\d*\.?\d+$/.test(e);function Ff(e,t){e.indexOf(t)===-1&&e.push(t)}function zf(e,t){const n=e.indexOf(t);n>-1&&e.splice(n,1)}class Vf{constructor(){this.subscriptions=[]}add(t){return Ff(this.subscriptions,t),()=>zf(this.subscriptions,t)}notify(t,n,r){const o=this.subscriptions.length;if(!!o)if(o===1)this.subscriptions[0](t,n,r);else for(let i=0;i<o;i++){const s=this.subscriptions[i];s&&s(t,n,r)}}getSize(){return this.subscriptions.length}clear(){this.subscriptions.length=0}}const LC=e=>!isNaN(parseFloat(e));class NC{constructor(t,n={}){this.version="10.18.0",this.timeDelta=0,this.lastUpdated=0,this.canTrackVelocity=!1,this.events={},this.updateAndNotify=(r,o=!0)=>{this.prev=this.current,this.current=r;const{delta:i,timestamp:s}=nt;this.lastUpdated!==s&&(this.timeDelta=i,this.lastUpdated=s,Se.postRender(this.scheduleVelocityCheck)),this.prev!==this.current&&this.events.change&&this.events.change.notify(this.current),this.events.velocityChange&&this.events.velocityChange.notify(this.getVelocity()),o&&this.events.renderRequest&&this.events.renderRequest.notify(this.current)},this.scheduleVelocityCheck=()=>Se.postRender(this.velocityCheck),this.velocityCheck=({timestamp:r})=>{r!==this.lastUpdated&&(this.prev=this.current,this.events.velocityChange&&this.events.velocityChange.notify(this.getVelocity()))},this.hasAnimated=!1,this.prev=this.current=t,this.canTrackVelocity=LC(this.current),this.owner=n.owner}onChange(t){return this.on("change",t)}on(t,n){this.events[t]||(this.events[t]=new Vf);const r=this.events[t].add(n);return t==="change"?()=>{r(),Se.read(()=>{this.events.change.getSize()||this.stop()})}:r}clearListeners(){for(const t in this.events)this.events[t].clear()}attach(t,n){this.passiveEffect=t,this.stopPassiveEffect=n}set(t,n=!0){!n||!this.passiveEffect?this.updateAndNotify(t,n):this.passiveEffect(t,this.updateAndNotify)}setWithVelocity(t,n,r){this.set(n),this.prev=t,this.timeDelta=r}jump(t){this.updateAndNotify(t),this.prev=t,this.stop(),this.stopPassiveEffect&&this.stopPassiveEffect()}get(){return this.current}getPrevious(){return this.prev}getVelocity(){return this.canTrackVelocity?Nv(parseFloat(this.current)-parseFloat(this.prev),this.timeDelta):0}start(t){return this.stop(),new Promise(n=>{this.hasAnimated=!0,this.animation=t(n),this.events.animationStart&&this.events.animationStart.notify()}).then(()=>{this.events.animationComplete&&this.events.animationComplete.notify(),this.clearAnimation()})}stop(){this.animation&&(this.animation.stop(),this.events.animationCancel&&this.events.animationCancel.notify()),this.clearAnimation()}isAnimating(){return!!this.animation}clearAnimation(){delete this.animation}destroy(){this.clearListeners(),this.stop(),this.stopPassiveEffect&&this.stopPassiveEffect()}}function Io(e,t){return new NC(e,t)}const Bv=e=>t=>t.test(e),_C={test:e=>e==="auto",parse:e=>e},Uv=[Lr,ne,an,En,G4,W4,_C],Uo=e=>Uv.find(Bv(e)),FC=[...Uv,at,tr],zC=e=>FC.find(Bv(e));function VC(e,t,n){e.hasValue(t)?e.getValue(t).set(n):e.addValue(t,Io(n))}function jC(e,t){const n=yl(e,t);let{transitionEnd:r={},transition:o={},...i}=n?e.makeTargetAnimatable(n,!1):{};i={...i,...r};for(const s in i){const a=s3(i[s]);VC(e,s,a)}}function BC(e,t,n){var r,o;const i=Object.keys(t).filter(a=>!e.hasValue(a)),s=i.length;if(!!s)for(let a=0;a<s;a++){const l=i[a],c=t[l];let u=null;Array.isArray(c)&&(u=c[0]),u===null&&(u=(o=(r=n[l])!==null&&r!==void 0?r:e.readValue(l))!==null&&o!==void 0?o:t[l]),u!=null&&(typeof u=="string"&&(jv(u)||Vv(u))?u=parseFloat(u):!zC(u)&&tr.test(c)&&(u=zv(l,c)),e.addValue(l,Io(u,{owner:e})),n[l]===void 0&&(n[l]=u),u!==null&&e.setBaseTarget(l,u))}}function UC(e,t){return t?(t[e]||t.default||t).from:void 0}function HC(e,t,n){const r={};for(const o in e){const i=UC(o,t);if(i!==void 0)r[o]=i;else{const s=n.getValue(o);s&&(r[o]=s.get())}}return r}function WC({protectedKeys:e,needsAnimating:t},n){const r=e.hasOwnProperty(n)&&t[n]!==!0;return t[n]=!1,r}function GC(e,t){const n=e.get();if(Array.isArray(t)){for(let r=0;r<t.length;r++)if(t[r]!==n)return!0}else return n!==t}function Hv(e,t,{delay:n=0,transitionOverride:r,type:o}={}){let{transition:i=e.getDefaultTransition(),transitionEnd:s,...a}=e.makeTargetAnimatable(t);const l=e.getValue("willChange");r&&(i=r);const c=[],u=o&&e.animationState&&e.animationState.getState()[o];for(const d in a){const p=e.getValue(d),y=a[d];if(!p||y===void 0||u&&WC(u,d))continue;const w={delay:n,elapsed:0,...Nf(i||{},d)};if(window.HandoffAppearAnimations){const g=e.getProps()[Wy];if(g){const h=window.HandoffAppearAnimations(g,d,p,Se);h!==null&&(w.elapsed=h,w.isHandoff=!0)}}let x=!w.isHandoff&&!GC(p,y);if(w.type==="spring"&&(p.getVelocity()||w.velocity)&&(x=!1),p.animation&&(x=!1),x)continue;p.start(_f(d,p,y,e.shouldReduceMotion&&$r.has(d)?{type:!1}:w));const b=p.animation;Ia(l)&&(l.add(d),b.then(()=>l.remove(d))),c.push(b)}return s&&Promise.all(c).then(()=>{s&&jC(e,s)}),c}function Gu(e,t,n={}){const r=yl(e,t,n.custom);let{transition:o=e.getDefaultTransition()||{}}=r||{};n.transitionOverride&&(o=n.transitionOverride);const i=r?()=>Promise.all(Hv(e,r,n)):()=>Promise.resolve(),s=e.variantChildren&&e.variantChildren.size?(l=0)=>{const{delayChildren:c=0,staggerChildren:u,staggerDirection:d}=o;return KC(e,t,c+l,u,d,n)}:()=>Promise.resolve(),{when:a}=o;if(a){const[l,c]=a==="beforeChildren"?[i,s]:[s,i];return l().then(()=>c())}else return Promise.all([i(),s(n.delay)])}function KC(e,t,n=0,r=0,o=1,i){const s=[],a=(e.variantChildren.size-1)*r,l=o===1?(c=0)=>c*r:(c=0)=>a-c*r;return Array.from(e.variantChildren).sort(YC).forEach((c,u)=>{c.notify("AnimationStart",t),s.push(Gu(c,t,{...i,delay:n+l(u)}).then(()=>c.notify("AnimationComplete",t)))}),Promise.all(s)}function YC(e,t){return e.sortNodePosition(t)}function QC(e,t,n={}){e.notify("AnimationStart",t);let r;if(Array.isArray(t)){const o=t.map(i=>Gu(e,i,n));r=Promise.all(o)}else if(typeof t=="string")r=Gu(e,t,n);else{const o=typeof t=="function"?yl(e,t,n.custom):t;r=Promise.all(Hv(e,o,n))}return r.then(()=>e.notify("AnimationComplete",t))}const XC=[...bf].reverse(),qC=bf.length;function ZC(e){return t=>Promise.all(t.map(({animation:n,options:r})=>QC(e,n,r)))}function JC(e){let t=ZC(e);const n=tS();let r=!0;const o=(l,c)=>{const u=yl(e,c);if(u){const{transition:d,transitionEnd:p,...y}=u;l={...l,...y,...p}}return l};function i(l){t=l(e)}function s(l,c){const u=e.getProps(),d=e.getVariantContext(!0)||{},p=[],y=new Set;let w={},x=1/0;for(let g=0;g<qC;g++){const h=XC[g],m=n[h],S=u[h]!==void 0?u[h]:d[h],E=zi(S),T=h===c?m.isActive:null;T===!1&&(x=g);let I=S===d[h]&&S!==u[h]&&E;if(I&&r&&e.manuallyAnimateOnMount&&(I=!1),m.protectedKeys={...w},!m.isActive&&T===null||!S&&!m.prevProp||hl(S)||typeof S=="boolean")continue;let L=eS(m.prevProp,S)||h===c&&m.isActive&&!I&&E||g>x&&E,_=!1;const re=Array.isArray(S)?S:[S];let J=re.reduce(o,{});T===!1&&(J={});const{prevResolvedValues:se={}}=m,j={...se,...J},Y=z=>{L=!0,y.has(z)&&(_=!0,y.delete(z)),m.needsAnimating[z]=!0};for(const z in j){const ee=J[z],$=se[z];if(w.hasOwnProperty(z))continue;let B=!1;ka(ee)&&ka($)?B=!hv(ee,$):B=ee!==$,B?ee!==void 0?Y(z):y.add(z):ee!==void 0&&y.has(z)?Y(z):m.protectedKeys[z]=!0}m.prevProp=S,m.prevResolvedValues=J,m.isActive&&(w={...w,...J}),r&&e.blockInitialAnimation&&(L=!1),L&&(!I||_)&&p.push(...re.map(z=>({animation:z,options:{type:h,...l}})))}if(y.size){const g={};y.forEach(h=>{const m=e.getBaseTarget(h);m!==void 0&&(g[h]=m)}),p.push({animation:g})}let b=Boolean(p.length);return r&&(u.initial===!1||u.initial===u.animate)&&!e.manuallyAnimateOnMount&&(b=!1),r=!1,b?t(p):Promise.resolve()}function a(l,c,u){var d;if(n[l].isActive===c)return Promise.resolve();(d=e.variantChildren)===null||d===void 0||d.forEach(y=>{var w;return(w=y.animationState)===null||w===void 0?void 0:w.setActive(l,c)}),n[l].isActive=c;const p=s(u,l);for(const y in n)n[y].protectedKeys={};return p}return{animateChanges:s,setActive:a,setAnimateFunction:i,getState:()=>n}}function eS(e,t){return typeof t=="string"?t!==e:Array.isArray(t)?!hv(t,e):!1}function cr(e=!1){return{isActive:e,protectedKeys:{},needsAnimating:{},prevResolvedValues:{}}}function tS(){return{animate:cr(!0),whileInView:cr(),whileHover:cr(),whileTap:cr(),whileDrag:cr(),whileFocus:cr(),exit:cr()}}class nS extends sr{constructor(t){super(t),t.animationState||(t.animationState=JC(t))}updateAnimationControlsSubscription(){const{animate:t}=this.node.getProps();this.unmount(),hl(t)&&(this.unmount=t.subscribe(this.node))}mount(){this.updateAnimationControlsSubscription()}update(){const{animate:t}=this.node.getProps(),{animate:n}=this.node.prevProps||{};t!==n&&this.updateAnimationControlsSubscription()}unmount(){}}let rS=0;class oS extends sr{constructor(){super(...arguments),this.id=rS++}update(){if(!this.node.presenceContext)return;const{isPresent:t,onExitComplete:n,custom:r}=this.node.presenceContext,{isPresent:o}=this.node.prevPresenceContext||{};if(!this.node.animationState||t===o)return;const i=this.node.animationState.setActive("exit",!t,{custom:r!=null?r:this.node.getProps().custom});n&&!t&&i.then(()=>n(this.id))}mount(){const{register:t}=this.node.presenceContext||{};t&&(this.unmount=t(this.id))}unmount(){}}const iS={animation:{Feature:nS},exit:{Feature:oS}},om=(e,t)=>Math.abs(e-t);function sS(e,t){const n=om(e.x,t.x),r=om(e.y,t.y);return Math.sqrt(n**2+r**2)}class Wv{constructor(t,n,{transformPagePoint:r,contextWindow:o,dragSnapToOrigin:i=!1}={}){if(this.startEvent=null,this.lastMoveEvent=null,this.lastMoveEventInfo=null,this.handlers={},this.contextWindow=window,this.updatePoint=()=>{if(!(this.lastMoveEvent&&this.lastMoveEventInfo))return;const d=pc(this.lastMoveEventInfo,this.history),p=this.startEvent!==null,y=sS(d.offset,{x:0,y:0})>=3;if(!p&&!y)return;const{point:w}=d,{timestamp:x}=nt;this.history.push({...w,timestamp:x});const{onStart:b,onMove:g}=this.handlers;p||(b&&b(this.lastMoveEvent,d),this.startEvent=this.lastMoveEvent),g&&g(this.lastMoveEvent,d)},this.handlePointerMove=(d,p)=>{this.lastMoveEvent=d,this.lastMoveEventInfo=hc(p,this.transformPagePoint),Se.update(this.updatePoint,!0)},this.handlePointerUp=(d,p)=>{this.end();const{onEnd:y,onSessionEnd:w,resumeAnimation:x}=this.handlers;if(this.dragSnapToOrigin&&x&&x(),!(this.lastMoveEvent&&this.lastMoveEventInfo))return;const b=pc(d.type==="pointercancel"?this.lastMoveEventInfo:hc(p,this.transformPagePoint),this.history);this.startEvent&&y&&y(d,b),w&&w(d,b)},!lv(t))return;this.dragSnapToOrigin=i,this.handlers=n,this.transformPagePoint=r,this.contextWindow=o||window;const s=gl(t),a=hc(s,this.transformPagePoint),{point:l}=a,{timestamp:c}=nt;this.history=[{...l,timestamp:c}];const{onSessionStart:u}=n;u&&u(t,pc(a,this.history)),this.removeListeners=Yn(yn(this.contextWindow,"pointermove",this.handlePointerMove),yn(this.contextWindow,"pointerup",this.handlePointerUp),yn(this.contextWindow,"pointercancel",this.handlePointerUp))}updateHandlers(t){this.handlers=t}end(){this.removeListeners&&this.removeListeners(),Sn(this.updatePoint)}}function hc(e,t){return t?{point:t(e.point)}:e}function im(e,t){return{x:e.x-t.x,y:e.y-t.y}}function pc({point:e},t){return{point:e,delta:im(e,Gv(t)),offset:im(e,aS(t)),velocity:lS(t,.1)}}function aS(e){return e[0]}function Gv(e){return e[e.length-1]}function lS(e,t){if(e.length<2)return{x:0,y:0};let n=e.length-1,r=null;const o=Gv(e);for(;n>=0&&(r=e[n],!(o.timestamp-r.timestamp>Qn(t)));)n--;if(!r)return{x:0,y:0};const i=vn(o.timestamp-r.timestamp);if(i===0)return{x:0,y:0};const s={x:(o.x-r.x)/i,y:(o.y-r.y)/i};return s.x===1/0&&(s.x=0),s.y===1/0&&(s.y=0),s}function St(e){return e.max-e.min}function Ku(e,t=0,n=.01){return Math.abs(e-t)<=n}function sm(e,t,n,r=.5){e.origin=r,e.originPoint=Re(t.min,t.max,e.origin),e.scale=St(n)/St(t),(Ku(e.scale,1,1e-4)||isNaN(e.scale))&&(e.scale=1),e.translate=Re(n.min,n.max,e.origin)-e.originPoint,(Ku(e.translate)||isNaN(e.translate))&&(e.translate=0)}function mi(e,t,n,r){sm(e.x,t.x,n.x,r?r.originX:void 0),sm(e.y,t.y,n.y,r?r.originY:void 0)}function am(e,t,n){e.min=n.min+t.min,e.max=e.min+St(t)}function cS(e,t,n){am(e.x,t.x,n.x),am(e.y,t.y,n.y)}function lm(e,t,n){e.min=t.min-n.min,e.max=e.min+St(t)}function gi(e,t,n){lm(e.x,t.x,n.x),lm(e.y,t.y,n.y)}function uS(e,{min:t,max:n},r){return t!==void 0&&e<t?e=r?Re(t,e,r.min):Math.max(e,t):n!==void 0&&e>n&&(e=r?Re(n,e,r.max):Math.min(e,n)),e}function cm(e,t,n){return{min:t!==void 0?e.min+t:void 0,max:n!==void 0?e.max+n-(e.max-e.min):void 0}}function dS(e,{top:t,left:n,bottom:r,right:o}){return{x:cm(e.x,n,o),y:cm(e.y,t,r)}}function um(e,t){let n=t.min-e.min,r=t.max-e.max;return t.max-t.min<e.max-e.min&&([n,r]=[r,n]),{min:n,max:r}}function fS(e,t){return{x:um(e.x,t.x),y:um(e.y,t.y)}}function hS(e,t){let n=.5;const r=St(e),o=St(t);return o>r?n=ji(t.min,t.max-r,e.min):r>o&&(n=ji(e.min,e.max-o,t.min)),er(0,1,n)}function pS(e,t){const n={};return t.min!==void 0&&(n.min=t.min-e.min),t.max!==void 0&&(n.max=t.max-e.min),n}const Yu=.35;function mS(e=Yu){return e===!1?e=0:e===!0&&(e=Yu),{x:dm(e,"left","right"),y:dm(e,"top","bottom")}}function dm(e,t,n){return{min:fm(e,t),max:fm(e,n)}}function fm(e,t){return typeof e=="number"?e:e[t]||0}const hm=()=>({translate:0,scale:1,origin:0,originPoint:0}),lo=()=>({x:hm(),y:hm()}),pm=()=>({min:0,max:0}),Ve=()=>({x:pm(),y:pm()});function Rt(e){return[e("x"),e("y")]}function Kv({top:e,left:t,right:n,bottom:r}){return{x:{min:t,max:n},y:{min:e,max:r}}}function gS({x:e,y:t}){return{top:t.min,right:e.max,bottom:t.max,left:e.min}}function yS(e,t){if(!t)return e;const n=t({x:e.left,y:e.top}),r=t({x:e.right,y:e.bottom});return{top:n.y,left:n.x,bottom:r.y,right:r.x}}function mc(e){return e===void 0||e===1}function Qu({scale:e,scaleX:t,scaleY:n}){return!mc(e)||!mc(t)||!mc(n)}function hr(e){return Qu(e)||Yv(e)||e.z||e.rotate||e.rotateX||e.rotateY}function Yv(e){return mm(e.x)||mm(e.y)}function mm(e){return e&&e!=="0%"}function Oa(e,t,n){const r=e-n,o=t*r;return n+o}function gm(e,t,n,r,o){return o!==void 0&&(e=Oa(e,o,r)),Oa(e,n,r)+t}function Xu(e,t=0,n=1,r,o){e.min=gm(e.min,t,n,r,o),e.max=gm(e.max,t,n,r,o)}function Qv(e,{x:t,y:n}){Xu(e.x,t.translate,t.scale,t.originPoint),Xu(e.y,n.translate,n.scale,n.originPoint)}function vS(e,t,n,r=!1){const o=n.length;if(!o)return;t.x=t.y=1;let i,s;for(let a=0;a<o;a++){i=n[a],s=i.projectionDelta;const l=i.instance;l&&l.style&&l.style.display==="contents"||(r&&i.options.layoutScroll&&i.scroll&&i!==i.root&&co(e,{x:-i.scroll.offset.x,y:-i.scroll.offset.y}),s&&(t.x*=s.x.scale,t.y*=s.y.scale,Qv(e,s)),r&&hr(i.latestValues)&&co(e,i.latestValues))}t.x=ym(t.x),t.y=ym(t.y)}function ym(e){return Number.isInteger(e)||e>1.0000000000001||e<.999999999999?e:1}function An(e,t){e.min=e.min+t,e.max=e.max+t}function vm(e,t,[n,r,o]){const i=t[o]!==void 0?t[o]:.5,s=Re(e.min,e.max,i);Xu(e,t[n],t[r],s,t.scale)}const xS=["x","scaleX","originX"],wS=["y","scaleY","originY"];function co(e,t){vm(e.x,t,xS),vm(e.y,t,wS)}function Xv(e,t){return Kv(yS(e.getBoundingClientRect(),t))}function bS(e,t,n){const r=Xv(e,n),{scroll:o}=t;return o&&(An(r.x,o.offset.x),An(r.y,o.offset.y)),r}const qv=({current:e})=>e?e.ownerDocument.defaultView:null,CS=new WeakMap;class SS{constructor(t){this.openGlobalLock=null,this.isDragging=!1,this.currentDirection=null,this.originPoint={x:0,y:0},this.constraints=!1,this.hasMutatedConstraints=!1,this.elastic=Ve(),this.visualElement=t}start(t,{snapToCursor:n=!1}={}){const{presenceContext:r}=this.visualElement;if(r&&r.isPresent===!1)return;const o=u=>{const{dragSnapToOrigin:d}=this.getProps();d?this.pauseAnimation():this.stopAnimation(),n&&this.snapToCursor(gl(u,"page").point)},i=(u,d)=>{const{drag:p,dragPropagation:y,onDragStart:w}=this.getProps();if(p&&!y&&(this.openGlobalLock&&this.openGlobalLock(),this.openGlobalLock=uv(p),!this.openGlobalLock))return;this.isDragging=!0,this.currentDirection=null,this.resolveConstraints(),this.visualElement.projection&&(this.visualElement.projection.isAnimationBlocked=!0,this.visualElement.projection.target=void 0),Rt(b=>{let g=this.getAxisMotionValue(b).get()||0;if(an.test(g)){const{projection:h}=this.visualElement;if(h&&h.layout){const m=h.layout.layoutBox[b];m&&(g=St(m)*(parseFloat(g)/100))}}this.originPoint[b]=g}),w&&Se.update(()=>w(u,d),!1,!0);const{animationState:x}=this.visualElement;x&&x.setActive("whileDrag",!0)},s=(u,d)=>{const{dragPropagation:p,dragDirectionLock:y,onDirectionLock:w,onDrag:x}=this.getProps();if(!p&&!this.openGlobalLock)return;const{offset:b}=d;if(y&&this.currentDirection===null){this.currentDirection=kS(b),this.currentDirection!==null&&w&&w(this.currentDirection);return}this.updateAxis("x",d.point,b),this.updateAxis("y",d.point,b),this.visualElement.render(),x&&x(u,d)},a=(u,d)=>this.stop(u,d),l=()=>Rt(u=>{var d;return this.getAnimationState(u)==="paused"&&((d=this.getAxisMotionValue(u).animation)===null||d===void 0?void 0:d.play())}),{dragSnapToOrigin:c}=this.getProps();this.panSession=new Wv(t,{onSessionStart:o,onStart:i,onMove:s,onSessionEnd:a,resumeAnimation:l},{transformPagePoint:this.visualElement.getTransformPagePoint(),dragSnapToOrigin:c,contextWindow:qv(this.visualElement)})}stop(t,n){const r=this.isDragging;if(this.cancel(),!r)return;const{velocity:o}=n;this.startAnimation(o);const{onDragEnd:i}=this.getProps();i&&Se.update(()=>i(t,n))}cancel(){this.isDragging=!1;const{projection:t,animationState:n}=this.visualElement;t&&(t.isAnimationBlocked=!1),this.panSession&&this.panSession.end(),this.panSession=void 0;const{dragPropagation:r}=this.getProps();!r&&this.openGlobalLock&&(this.openGlobalLock(),this.openGlobalLock=null),n&&n.setActive("whileDrag",!1)}updateAxis(t,n,r){const{drag:o}=this.getProps();if(!r||!ks(t,o,this.currentDirection))return;const i=this.getAxisMotionValue(t);let s=this.originPoint[t]+r[t];this.constraints&&this.constraints[t]&&(s=uS(s,this.constraints[t],this.elastic[t])),i.set(s)}resolveConstraints(){var t;const{dragConstraints:n,dragElastic:r}=this.getProps(),o=this.visualElement.projection&&!this.visualElement.projection.layout?this.visualElement.projection.measure(!1):(t=this.visualElement.projection)===null||t===void 0?void 0:t.layout,i=this.constraints;n&&so(n)?this.constraints||(this.constraints=this.resolveRefConstraints()):n&&o?this.constraints=dS(o.layoutBox,n):this.constraints=!1,this.elastic=mS(r),i!==this.constraints&&o&&this.constraints&&!this.hasMutatedConstraints&&Rt(s=>{this.getAxisMotionValue(s)&&(this.constraints[s]=pS(o.layoutBox[s],this.constraints[s]))})}resolveRefConstraints(){const{dragConstraints:t,onMeasureDragConstraints:n}=this.getProps();if(!t||!so(t))return!1;const r=t.current,{projection:o}=this.visualElement;if(!o||!o.layout)return!1;const i=bS(r,o.root,this.visualElement.getTransformPagePoint());let s=fS(o.layout.layoutBox,i);if(n){const a=n(gS(s));this.hasMutatedConstraints=!!a,a&&(s=Kv(a))}return s}startAnimation(t){const{drag:n,dragMomentum:r,dragElastic:o,dragTransition:i,dragSnapToOrigin:s,onDragTransitionEnd:a}=this.getProps(),l=this.constraints||{},c=Rt(u=>{if(!ks(u,n,this.currentDirection))return;let d=l&&l[u]||{};s&&(d={min:0,max:0});const p=o?200:1e6,y=o?40:1e7,w={type:"inertia",velocity:r?t[u]:0,bounceStiffness:p,bounceDamping:y,timeConstant:750,restDelta:1,restSpeed:10,...i,...d};return this.startAxisValueAnimation(u,w)});return Promise.all(c).then(a)}startAxisValueAnimation(t,n){const r=this.getAxisMotionValue(t);return r.start(_f(t,r,0,n))}stopAnimation(){Rt(t=>this.getAxisMotionValue(t).stop())}pauseAnimation(){Rt(t=>{var n;return(n=this.getAxisMotionValue(t).animation)===null||n===void 0?void 0:n.pause()})}getAnimationState(t){var n;return(n=this.getAxisMotionValue(t).animation)===null||n===void 0?void 0:n.state}getAxisMotionValue(t){const n="_drag"+t.toUpperCase(),r=this.visualElement.getProps(),o=r[n];return o||this.visualElement.getValue(t,(r.initial?r.initial[t]:void 0)||0)}snapToCursor(t){Rt(n=>{const{drag:r}=this.getProps();if(!ks(n,r,this.currentDirection))return;const{projection:o}=this.visualElement,i=this.getAxisMotionValue(n);if(o&&o.layout){const{min:s,max:a}=o.layout.layoutBox[n];i.set(t[n]-Re(s,a,.5))}})}scalePositionWithinConstraints(){if(!this.visualElement.current)return;const{drag:t,dragConstraints:n}=this.getProps(),{projection:r}=this.visualElement;if(!so(n)||!r||!this.constraints)return;this.stopAnimation();const o={x:0,y:0};Rt(s=>{const a=this.getAxisMotionValue(s);if(a){const l=a.get();o[s]=hS({min:l,max:l},this.constraints[s])}});const{transformTemplate:i}=this.visualElement.getProps();this.visualElement.current.style.transform=i?i({},""):"none",r.root&&r.root.updateScroll(),r.updateLayout(),this.resolveConstraints(),Rt(s=>{if(!ks(s,t,null))return;const a=this.getAxisMotionValue(s),{min:l,max:c}=this.constraints[s];a.set(Re(l,c,o[s]))})}addListeners(){if(!this.visualElement.current)return;CS.set(this.visualElement,this);const t=this.visualElement.current,n=yn(t,"pointerdown",l=>{const{drag:c,dragListener:u=!0}=this.getProps();c&&u&&this.start(l)}),r=()=>{const{dragConstraints:l}=this.getProps();so(l)&&(this.constraints=this.resolveRefConstraints())},{projection:o}=this.visualElement,i=o.addEventListener("measure",r);o&&!o.layout&&(o.root&&o.root.updateScroll(),o.updateLayout()),r();const s=mn(window,"resize",()=>this.scalePositionWithinConstraints()),a=o.addEventListener("didUpdate",({delta:l,hasLayoutChanged:c})=>{this.isDragging&&c&&(Rt(u=>{const d=this.getAxisMotionValue(u);!d||(this.originPoint[u]+=l[u].translate,d.set(d.get()+l[u].translate))}),this.visualElement.render())});return()=>{s(),n(),i(),a&&a()}}getProps(){const t=this.visualElement.getProps(),{drag:n=!1,dragDirectionLock:r=!1,dragPropagation:o=!1,dragConstraints:i=!1,dragElastic:s=Yu,dragMomentum:a=!0}=t;return{...t,drag:n,dragDirectionLock:r,dragPropagation:o,dragConstraints:i,dragElastic:s,dragMomentum:a}}}function ks(e,t,n){return(t===!0||t===e)&&(n===null||n===e)}function kS(e,t=10){let n=null;return Math.abs(e.y)>t?n="y":Math.abs(e.x)>t&&(n="x"),n}class PS extends sr{constructor(t){super(t),this.removeGroupControls=_e,this.removeListeners=_e,this.controls=new SS(t)}mount(){const{dragControls:t}=this.node.getProps();t&&(this.removeGroupControls=t.subscribe(this.controls)),this.removeListeners=this.controls.addListeners()||_e}unmount(){this.removeGroupControls(),this.removeListeners()}}const xm=e=>(t,n)=>{e&&Se.update(()=>e(t,n))};class TS extends sr{constructor(){super(...arguments),this.removePointerDownListener=_e}onPointerDown(t){this.session=new Wv(t,this.createPanHandlers(),{transformPagePoint:this.node.getTransformPagePoint(),contextWindow:qv(this.node)})}createPanHandlers(){const{onPanSessionStart:t,onPanStart:n,onPan:r,onPanEnd:o}=this.node.getProps();return{onSessionStart:xm(t),onStart:xm(n),onMove:r,onEnd:(i,s)=>{delete this.session,o&&Se.update(()=>o(i,s))}}}mount(){this.removePointerDownListener=yn(this.node.current,"pointerdown",t=>this.onPointerDown(t))}update(){this.session&&this.session.updateHandlers(this.createPanHandlers())}unmount(){this.removePointerDownListener(),this.session&&this.session.end()}}function ES(){const e=v.exports.useContext(dl);if(e===null)return[!0,null];const{isPresent:t,onExitComplete:n,register:r}=e,o=v.exports.useId();return v.exports.useEffect(()=>r(o),[]),!t&&n?[!1,()=>n&&n(o)]:[!0]}const Us={hasAnimatedSinceResize:!0,hasEverUpdated:!1};function wm(e,t){return t.max===t.min?0:e/(t.max-t.min)*100}const Ho={correct:(e,t)=>{if(!t.target)return e;if(typeof e=="string")if(ne.test(e))e=parseFloat(e);else return e;const n=wm(e,t.target.x),r=wm(e,t.target.y);return`${n}% ${r}%`}},IS={correct:(e,{treeScale:t,projectionDelta:n})=>{const r=e,o=tr.parse(e);if(o.length>5)return r;const i=tr.createTransformer(e),s=typeof o[0]!="number"?1:0,a=n.x.scale*t.x,l=n.y.scale*t.y;o[0+s]/=a,o[1+s]/=l;const c=Re(a,l,.5);return typeof o[2+s]=="number"&&(o[2+s]/=c),typeof o[3+s]=="number"&&(o[3+s]/=c),i(o)}};var xl={exports:{}},wl={};/**
 * @license React
 * react-jsx-runtime.production.min.js
 *
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */var OS=v.exports,AS=Symbol.for("react.element"),DS=Symbol.for("react.fragment"),MS=Object.prototype.hasOwnProperty,RS=OS.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED.ReactCurrentOwner,$S={key:!0,ref:!0,__self:!0,__source:!0};function Zv(e,t,n){var r,o={},i=null,s=null;n!==void 0&&(i=""+n),t.key!==void 0&&(i=""+t.key),t.ref!==void 0&&(s=t.ref);for(r in t)MS.call(t,r)&&!$S.hasOwnProperty(r)&&(o[r]=t[r]);if(e&&e.defaultProps)for(r in t=e.defaultProps,t)o[r]===void 0&&(o[r]=t[r]);return{$$typeof:AS,type:e,key:i,ref:s,props:o,_owner:RS.current}}wl.Fragment=DS;wl.jsx=Zv;wl.jsxs=Zv;xl.exports=wl;const f=xl.exports.jsx,P=xl.exports.jsxs,pe=xl.exports.Fragment;class LS extends Ke.Component{componentDidMount(){const{visualElement:t,layoutGroup:n,switchLayoutGroup:r,layoutId:o}=this.props,{projection:i}=t;F4(NS),i&&(n.group&&n.group.add(i),r&&r.register&&o&&r.register(i),i.root.didUpdate(),i.addEventListener("animationComplete",()=>{this.safeToRemove()}),i.setOptions({...i.options,onExitComplete:()=>this.safeToRemove()})),Us.hasEverUpdated=!0}getSnapshotBeforeUpdate(t){const{layoutDependency:n,visualElement:r,drag:o,isPresent:i}=this.props,s=r.projection;return s&&(s.isPresent=i,o||t.layoutDependency!==n||n===void 0?s.willUpdate():this.safeToRemove(),t.isPresent!==i&&(i?s.promote():s.relegate()||Se.postRender(()=>{const a=s.getStack();(!a||!a.members.length)&&this.safeToRemove()}))),null}componentDidUpdate(){const{projection:t}=this.props.visualElement;t&&(t.root.didUpdate(),queueMicrotask(()=>{!t.currentAnimation&&t.isLead()&&this.safeToRemove()}))}componentWillUnmount(){const{visualElement:t,layoutGroup:n,switchLayoutGroup:r}=this.props,{projection:o}=t;o&&(o.scheduleCheckAfterUnmount(),n&&n.group&&n.group.remove(o),r&&r.deregister&&r.deregister(o))}safeToRemove(){const{safeToRemove:t}=this.props;t&&t()}render(){return null}}function Jv(e){const[t,n]=ES(),r=v.exports.useContext(Sf);return f(LS,{...e,layoutGroup:r,switchLayoutGroup:v.exports.useContext(Ky),isPresent:t,safeToRemove:n})}const NS={borderRadius:{...Ho,applyTo:["borderTopLeftRadius","borderTopRightRadius","borderBottomLeftRadius","borderBottomRightRadius"]},borderTopLeftRadius:Ho,borderTopRightRadius:Ho,borderBottomLeftRadius:Ho,borderBottomRightRadius:Ho,boxShadow:IS},e5=["TopLeft","TopRight","BottomLeft","BottomRight"],_S=e5.length,bm=e=>typeof e=="string"?parseFloat(e):e,Cm=e=>typeof e=="number"||ne.test(e);function FS(e,t,n,r,o,i){o?(e.opacity=Re(0,n.opacity!==void 0?n.opacity:1,zS(r)),e.opacityExit=Re(t.opacity!==void 0?t.opacity:1,0,VS(r))):i&&(e.opacity=Re(t.opacity!==void 0?t.opacity:1,n.opacity!==void 0?n.opacity:1,r));for(let s=0;s<_S;s++){const a=`border${e5[s]}Radius`;let l=Sm(t,a),c=Sm(n,a);if(l===void 0&&c===void 0)continue;l||(l=0),c||(c=0),l===0||c===0||Cm(l)===Cm(c)?(e[a]=Math.max(Re(bm(l),bm(c),r),0),(an.test(c)||an.test(l))&&(e[a]+="%")):e[a]=c}(t.rotate||n.rotate)&&(e.rotate=Re(t.rotate||0,n.rotate||0,r))}function Sm(e,t){return e[t]!==void 0?e[t]:e.borderRadius}const zS=t5(0,.5,Cv),VS=t5(.5,.95,_e);function t5(e,t,n){return r=>r<e?0:r>t?1:n(ji(e,t,r))}function km(e,t){e.min=t.min,e.max=t.max}function At(e,t){km(e.x,t.x),km(e.y,t.y)}function Pm(e,t,n,r,o){return e-=t,e=Oa(e,1/n,r),o!==void 0&&(e=Oa(e,1/o,r)),e}function jS(e,t=0,n=1,r=.5,o,i=e,s=e){if(an.test(t)&&(t=parseFloat(t),t=Re(s.min,s.max,t/100)-s.min),typeof t!="number")return;let a=Re(i.min,i.max,r);e===i&&(a-=t),e.min=Pm(e.min,t,n,a,o),e.max=Pm(e.max,t,n,a,o)}function Tm(e,t,[n,r,o],i,s){jS(e,t[n],t[r],t[o],t.scale,i,s)}const BS=["x","scaleX","originX"],US=["y","scaleY","originY"];function Em(e,t,n,r){Tm(e.x,t,BS,n?n.x:void 0,r?r.x:void 0),Tm(e.y,t,US,n?n.y:void 0,r?r.y:void 0)}function Im(e){return e.translate===0&&e.scale===1}function n5(e){return Im(e.x)&&Im(e.y)}function HS(e,t){return e.x.min===t.x.min&&e.x.max===t.x.max&&e.y.min===t.y.min&&e.y.max===t.y.max}function r5(e,t){return Math.round(e.x.min)===Math.round(t.x.min)&&Math.round(e.x.max)===Math.round(t.x.max)&&Math.round(e.y.min)===Math.round(t.y.min)&&Math.round(e.y.max)===Math.round(t.y.max)}function Om(e){return St(e.x)/St(e.y)}class WS{constructor(){this.members=[]}add(t){Ff(this.members,t),t.scheduleRender()}remove(t){if(zf(this.members,t),t===this.prevLead&&(this.prevLead=void 0),t===this.lead){const n=this.members[this.members.length-1];n&&this.promote(n)}}relegate(t){const n=this.members.findIndex(o=>t===o);if(n===0)return!1;let r;for(let o=n;o>=0;o--){const i=this.members[o];if(i.isPresent!==!1){r=i;break}}return r?(this.promote(r),!0):!1}promote(t,n){const r=this.lead;if(t!==r&&(this.prevLead=r,this.lead=t,t.show(),r)){r.instance&&r.scheduleRender(),t.scheduleRender(),t.resumeFrom=r,n&&(t.resumeFrom.preserveOpacity=!0),r.snapshot&&(t.snapshot=r.snapshot,t.snapshot.latestValues=r.animationValues||r.latestValues),t.root&&t.root.isUpdating&&(t.isLayoutDirty=!0);const{crossfade:o}=t.options;o===!1&&r.hide()}}exitAnimationComplete(){this.members.forEach(t=>{const{options:n,resumingFrom:r}=t;n.onExitComplete&&n.onExitComplete(),r&&r.options.onExitComplete&&r.options.onExitComplete()})}scheduleRender(){this.members.forEach(t=>{t.instance&&t.scheduleRender(!1)})}removeLeadSnapshot(){this.lead&&this.lead.snapshot&&(this.lead.snapshot=void 0)}}function Am(e,t,n){let r="";const o=e.x.translate/t.x,i=e.y.translate/t.y;if((o||i)&&(r=`translate3d(${o}px, ${i}px, 0) `),(t.x!==1||t.y!==1)&&(r+=`scale(${1/t.x}, ${1/t.y}) `),n){const{rotate:l,rotateX:c,rotateY:u}=n;l&&(r+=`rotate(${l}deg) `),c&&(r+=`rotateX(${c}deg) `),u&&(r+=`rotateY(${u}deg) `)}const s=e.x.scale*t.x,a=e.y.scale*t.y;return(s!==1||a!==1)&&(r+=`scale(${s}, ${a})`),r||"none"}const GS=(e,t)=>e.depth-t.depth;class KS{constructor(){this.children=[],this.isDirty=!1}add(t){Ff(this.children,t),this.isDirty=!0}remove(t){zf(this.children,t),this.isDirty=!0}forEach(t){this.isDirty&&this.children.sort(GS),this.isDirty=!1,this.children.forEach(t)}}function YS(e,t){const n=performance.now(),r=({timestamp:o})=>{const i=o-n;i>=t&&(Sn(r),e(i-t))};return Se.read(r,!0),()=>Sn(r)}function QS(e){window.MotionDebug&&window.MotionDebug.record(e)}function XS(e){return e instanceof SVGElement&&e.tagName!=="svg"}function qS(e,t,n){const r=vt(e)?e:Io(e);return r.start(_f("",r,t,n)),r.animation}const Dm=["","X","Y","Z"],ZS={visibility:"hidden"},Mm=1e3;let JS=0;const pr={type:"projectionFrame",totalNodes:0,resolvedTargetDeltas:0,recalculatedProjection:0};function o5({attachResizeListener:e,defaultParent:t,measureScroll:n,checkIsScrollRoot:r,resetTransform:o}){return class{constructor(s={},a=t==null?void 0:t()){this.id=JS++,this.animationId=0,this.children=new Set,this.options={},this.isTreeAnimating=!1,this.isAnimationBlocked=!1,this.isLayoutDirty=!1,this.isProjectionDirty=!1,this.isSharedProjectionDirty=!1,this.isTransformDirty=!1,this.updateManuallyBlocked=!1,this.updateBlockedByResize=!1,this.isUpdating=!1,this.isSVG=!1,this.needsReset=!1,this.shouldResetTransform=!1,this.treeScale={x:1,y:1},this.eventHandlers=new Map,this.hasTreeAnimated=!1,this.updateScheduled=!1,this.projectionUpdateScheduled=!1,this.checkUpdateFailed=()=>{this.isUpdating&&(this.isUpdating=!1,this.clearAllSnapshots())},this.updateProjection=()=>{this.projectionUpdateScheduled=!1,pr.totalNodes=pr.resolvedTargetDeltas=pr.recalculatedProjection=0,this.nodes.forEach(n6),this.nodes.forEach(a6),this.nodes.forEach(l6),this.nodes.forEach(r6),QS(pr)},this.hasProjected=!1,this.isVisible=!0,this.animationProgress=0,this.sharedNodes=new Map,this.latestValues=s,this.root=a?a.root||a:this,this.path=a?[...a.path,a]:[],this.parent=a,this.depth=a?a.depth+1:0;for(let l=0;l<this.path.length;l++)this.path[l].shouldResetTransform=!0;this.root===this&&(this.nodes=new KS)}addEventListener(s,a){return this.eventHandlers.has(s)||this.eventHandlers.set(s,new Vf),this.eventHandlers.get(s).add(a)}notifyListeners(s,...a){const l=this.eventHandlers.get(s);l&&l.notify(...a)}hasListeners(s){return this.eventHandlers.has(s)}mount(s,a=this.root.hasTreeAnimated){if(this.instance)return;this.isSVG=XS(s),this.instance=s;const{layoutId:l,layout:c,visualElement:u}=this.options;if(u&&!u.current&&u.mount(s),this.root.nodes.add(this),this.parent&&this.parent.children.add(this),a&&(c||l)&&(this.isLayoutDirty=!0),e){let d;const p=()=>this.root.updateBlockedByResize=!1;e(s,()=>{this.root.updateBlockedByResize=!0,d&&d(),d=YS(p,250),Us.hasAnimatedSinceResize&&(Us.hasAnimatedSinceResize=!1,this.nodes.forEach($m))})}l&&this.root.registerSharedNode(l,this),this.options.animate!==!1&&u&&(l||c)&&this.addEventListener("didUpdate",({delta:d,hasLayoutChanged:p,hasRelativeTargetChanged:y,layout:w})=>{if(this.isTreeAnimationBlocked()){this.target=void 0,this.relativeTarget=void 0;return}const x=this.options.transition||u.getDefaultTransition()||h6,{onLayoutAnimationStart:b,onLayoutAnimationComplete:g}=u.getProps(),h=!this.targetLayout||!r5(this.targetLayout,w)||y,m=!p&&y;if(this.options.layoutRoot||this.resumeFrom&&this.resumeFrom.instance||m||p&&(h||!this.currentAnimation)){this.resumeFrom&&(this.resumingFrom=this.resumeFrom,this.resumingFrom.resumingFrom=void 0),this.setAnimationOrigin(d,m);const S={...Nf(x,"layout"),onPlay:b,onComplete:g};(u.shouldReduceMotion||this.options.layoutRoot)&&(S.delay=0,S.type=!1),this.startAnimation(S)}else p||$m(this),this.isLead()&&this.options.onExitComplete&&this.options.onExitComplete();this.targetLayout=w})}unmount(){this.options.layoutId&&this.willUpdate(),this.root.nodes.remove(this);const s=this.getStack();s&&s.remove(this),this.parent&&this.parent.children.delete(this),this.instance=void 0,Sn(this.updateProjection)}blockUpdate(){this.updateManuallyBlocked=!0}unblockUpdate(){this.updateManuallyBlocked=!1}isUpdateBlocked(){return this.updateManuallyBlocked||this.updateBlockedByResize}isTreeAnimationBlocked(){return this.isAnimationBlocked||this.parent&&this.parent.isTreeAnimationBlocked()||!1}startUpdate(){this.isUpdateBlocked()||(this.isUpdating=!0,this.nodes&&this.nodes.forEach(c6),this.animationId++)}getTransformTemplate(){const{visualElement:s}=this.options;return s&&s.getProps().transformTemplate}willUpdate(s=!0){if(this.root.hasTreeAnimated=!0,this.root.isUpdateBlocked()){this.options.onExitComplete&&this.options.onExitComplete();return}if(!this.root.isUpdating&&this.root.startUpdate(),this.isLayoutDirty)return;this.isLayoutDirty=!0;for(let u=0;u<this.path.length;u++){const d=this.path[u];d.shouldResetTransform=!0,d.updateScroll("snapshot"),d.options.layoutRoot&&d.willUpdate(!1)}const{layoutId:a,layout:l}=this.options;if(a===void 0&&!l)return;const c=this.getTransformTemplate();this.prevTransformTemplateValue=c?c(this.latestValues,""):void 0,this.updateSnapshot(),s&&this.notifyListeners("willUpdate")}update(){if(this.updateScheduled=!1,this.isUpdateBlocked()){this.unblockUpdate(),this.clearAllSnapshots(),this.nodes.forEach(Rm);return}this.isUpdating||this.nodes.forEach(i6),this.isUpdating=!1,this.nodes.forEach(s6),this.nodes.forEach(e6),this.nodes.forEach(t6),this.clearAllSnapshots();const a=performance.now();nt.delta=er(0,1e3/60,a-nt.timestamp),nt.timestamp=a,nt.isProcessing=!0,ic.update.process(nt),ic.preRender.process(nt),ic.render.process(nt),nt.isProcessing=!1}didUpdate(){this.updateScheduled||(this.updateScheduled=!0,queueMicrotask(()=>this.update()))}clearAllSnapshots(){this.nodes.forEach(o6),this.sharedNodes.forEach(u6)}scheduleUpdateProjection(){this.projectionUpdateScheduled||(this.projectionUpdateScheduled=!0,Se.preRender(this.updateProjection,!1,!0))}scheduleCheckAfterUnmount(){Se.postRender(()=>{this.isLayoutDirty?this.root.didUpdate():this.root.checkUpdateFailed()})}updateSnapshot(){this.snapshot||!this.instance||(this.snapshot=this.measure())}updateLayout(){if(!this.instance||(this.updateScroll(),!(this.options.alwaysMeasureLayout&&this.isLead())&&!this.isLayoutDirty))return;if(this.resumeFrom&&!this.resumeFrom.instance)for(let l=0;l<this.path.length;l++)this.path[l].updateScroll();const s=this.layout;this.layout=this.measure(!1),this.layoutCorrected=Ve(),this.isLayoutDirty=!1,this.projectionDelta=void 0,this.notifyListeners("measure",this.layout.layoutBox);const{visualElement:a}=this.options;a&&a.notify("LayoutMeasure",this.layout.layoutBox,s?s.layoutBox:void 0)}updateScroll(s="measure"){let a=Boolean(this.options.layoutScroll&&this.instance);this.scroll&&this.scroll.animationId===this.root.animationId&&this.scroll.phase===s&&(a=!1),a&&(this.scroll={animationId:this.root.animationId,phase:s,isRoot:r(this.instance),offset:n(this.instance)})}resetTransform(){if(!o)return;const s=this.isLayoutDirty||this.shouldResetTransform,a=this.projectionDelta&&!n5(this.projectionDelta),l=this.getTransformTemplate(),c=l?l(this.latestValues,""):void 0,u=c!==this.prevTransformTemplateValue;s&&(a||hr(this.latestValues)||u)&&(o(this.instance,c),this.shouldResetTransform=!1,this.scheduleRender())}measure(s=!0){const a=this.measurePageBox();let l=this.removeElementScroll(a);return s&&(l=this.removeTransform(l)),p6(l),{animationId:this.root.animationId,measuredBox:a,layoutBox:l,latestValues:{},source:this.id}}measurePageBox(){const{visualElement:s}=this.options;if(!s)return Ve();const a=s.measureViewportBox(),{scroll:l}=this.root;return l&&(An(a.x,l.offset.x),An(a.y,l.offset.y)),a}removeElementScroll(s){const a=Ve();At(a,s);for(let l=0;l<this.path.length;l++){const c=this.path[l],{scroll:u,options:d}=c;if(c!==this.root&&u&&d.layoutScroll){if(u.isRoot){At(a,s);const{scroll:p}=this.root;p&&(An(a.x,-p.offset.x),An(a.y,-p.offset.y))}An(a.x,u.offset.x),An(a.y,u.offset.y)}}return a}applyTransform(s,a=!1){const l=Ve();At(l,s);for(let c=0;c<this.path.length;c++){const u=this.path[c];!a&&u.options.layoutScroll&&u.scroll&&u!==u.root&&co(l,{x:-u.scroll.offset.x,y:-u.scroll.offset.y}),hr(u.latestValues)&&co(l,u.latestValues)}return hr(this.latestValues)&&co(l,this.latestValues),l}removeTransform(s){const a=Ve();At(a,s);for(let l=0;l<this.path.length;l++){const c=this.path[l];if(!c.instance||!hr(c.latestValues))continue;Qu(c.latestValues)&&c.updateSnapshot();const u=Ve(),d=c.measurePageBox();At(u,d),Em(a,c.latestValues,c.snapshot?c.snapshot.layoutBox:void 0,u)}return hr(this.latestValues)&&Em(a,this.latestValues),a}setTargetDelta(s){this.targetDelta=s,this.root.scheduleUpdateProjection(),this.isProjectionDirty=!0}setOptions(s){this.options={...this.options,...s,crossfade:s.crossfade!==void 0?s.crossfade:!0}}clearMeasurements(){this.scroll=void 0,this.layout=void 0,this.snapshot=void 0,this.prevTransformTemplateValue=void 0,this.targetDelta=void 0,this.target=void 0,this.isLayoutDirty=!1}forceRelativeParentToResolveTarget(){!this.relativeParent||this.relativeParent.resolvedRelativeTargetAt!==nt.timestamp&&this.relativeParent.resolveTargetDelta(!0)}resolveTargetDelta(s=!1){var a;const l=this.getLead();this.isProjectionDirty||(this.isProjectionDirty=l.isProjectionDirty),this.isTransformDirty||(this.isTransformDirty=l.isTransformDirty),this.isSharedProjectionDirty||(this.isSharedProjectionDirty=l.isSharedProjectionDirty);const c=Boolean(this.resumingFrom)||this!==l;if(!(s||c&&this.isSharedProjectionDirty||this.isProjectionDirty||((a=this.parent)===null||a===void 0?void 0:a.isProjectionDirty)||this.attemptToResolveRelativeTarget))return;const{layout:d,layoutId:p}=this.options;if(!(!this.layout||!(d||p))){if(this.resolvedRelativeTargetAt=nt.timestamp,!this.targetDelta&&!this.relativeTarget){const y=this.getClosestProjectingParent();y&&y.layout&&this.animationProgress!==1?(this.relativeParent=y,this.forceRelativeParentToResolveTarget(),this.relativeTarget=Ve(),this.relativeTargetOrigin=Ve(),gi(this.relativeTargetOrigin,this.layout.layoutBox,y.layout.layoutBox),At(this.relativeTarget,this.relativeTargetOrigin)):this.relativeParent=this.relativeTarget=void 0}if(!(!this.relativeTarget&&!this.targetDelta)){if(this.target||(this.target=Ve(),this.targetWithTransforms=Ve()),this.relativeTarget&&this.relativeTargetOrigin&&this.relativeParent&&this.relativeParent.target?(this.forceRelativeParentToResolveTarget(),cS(this.target,this.relativeTarget,this.relativeParent.target)):this.targetDelta?(Boolean(this.resumingFrom)?this.target=this.applyTransform(this.layout.layoutBox):At(this.target,this.layout.layoutBox),Qv(this.target,this.targetDelta)):At(this.target,this.layout.layoutBox),this.attemptToResolveRelativeTarget){this.attemptToResolveRelativeTarget=!1;const y=this.getClosestProjectingParent();y&&Boolean(y.resumingFrom)===Boolean(this.resumingFrom)&&!y.options.layoutScroll&&y.target&&this.animationProgress!==1?(this.relativeParent=y,this.forceRelativeParentToResolveTarget(),this.relativeTarget=Ve(),this.relativeTargetOrigin=Ve(),gi(this.relativeTargetOrigin,this.target,y.target),At(this.relativeTarget,this.relativeTargetOrigin)):this.relativeParent=this.relativeTarget=void 0}pr.resolvedTargetDeltas++}}}getClosestProjectingParent(){if(!(!this.parent||Qu(this.parent.latestValues)||Yv(this.parent.latestValues)))return this.parent.isProjecting()?this.parent:this.parent.getClosestProjectingParent()}isProjecting(){return Boolean((this.relativeTarget||this.targetDelta||this.options.layoutRoot)&&this.layout)}calcProjection(){var s;const a=this.getLead(),l=Boolean(this.resumingFrom)||this!==a;let c=!0;if((this.isProjectionDirty||((s=this.parent)===null||s===void 0?void 0:s.isProjectionDirty))&&(c=!1),l&&(this.isSharedProjectionDirty||this.isTransformDirty)&&(c=!1),this.resolvedRelativeTargetAt===nt.timestamp&&(c=!1),c)return;const{layout:u,layoutId:d}=this.options;if(this.isTreeAnimating=Boolean(this.parent&&this.parent.isTreeAnimating||this.currentAnimation||this.pendingAnimation),this.isTreeAnimating||(this.targetDelta=this.relativeTarget=void 0),!this.layout||!(u||d))return;At(this.layoutCorrected,this.layout.layoutBox);const p=this.treeScale.x,y=this.treeScale.y;vS(this.layoutCorrected,this.treeScale,this.path,l),a.layout&&!a.target&&(this.treeScale.x!==1||this.treeScale.y!==1)&&(a.target=a.layout.layoutBox);const{target:w}=a;if(!w){this.projectionTransform&&(this.projectionDelta=lo(),this.projectionTransform="none",this.scheduleRender());return}this.projectionDelta||(this.projectionDelta=lo(),this.projectionDeltaWithTransform=lo());const x=this.projectionTransform;mi(this.projectionDelta,this.layoutCorrected,w,this.latestValues),this.projectionTransform=Am(this.projectionDelta,this.treeScale),(this.projectionTransform!==x||this.treeScale.x!==p||this.treeScale.y!==y)&&(this.hasProjected=!0,this.scheduleRender(),this.notifyListeners("projectionUpdate",w)),pr.recalculatedProjection++}hide(){this.isVisible=!1}show(){this.isVisible=!0}scheduleRender(s=!0){if(this.options.scheduleRender&&this.options.scheduleRender(),s){const a=this.getStack();a&&a.scheduleRender()}this.resumingFrom&&!this.resumingFrom.instance&&(this.resumingFrom=void 0)}setAnimationOrigin(s,a=!1){const l=this.snapshot,c=l?l.latestValues:{},u={...this.latestValues},d=lo();(!this.relativeParent||!this.relativeParent.options.layoutRoot)&&(this.relativeTarget=this.relativeTargetOrigin=void 0),this.attemptToResolveRelativeTarget=!a;const p=Ve(),y=l?l.source:void 0,w=this.layout?this.layout.source:void 0,x=y!==w,b=this.getStack(),g=!b||b.members.length<=1,h=Boolean(x&&!g&&this.options.crossfade===!0&&!this.path.some(f6));this.animationProgress=0;let m;this.mixTargetDelta=S=>{const E=S/1e3;Lm(d.x,s.x,E),Lm(d.y,s.y,E),this.setTargetDelta(d),this.relativeTarget&&this.relativeTargetOrigin&&this.layout&&this.relativeParent&&this.relativeParent.layout&&(gi(p,this.layout.layoutBox,this.relativeParent.layout.layoutBox),d6(this.relativeTarget,this.relativeTargetOrigin,p,E),m&&HS(this.relativeTarget,m)&&(this.isProjectionDirty=!1),m||(m=Ve()),At(m,this.relativeTarget)),x&&(this.animationValues=u,FS(u,c,this.latestValues,E,h,g)),this.root.scheduleUpdateProjection(),this.scheduleRender(),this.animationProgress=E},this.mixTargetDelta(this.options.layoutRoot?1e3:0)}startAnimation(s){this.notifyListeners("animationStart"),this.currentAnimation&&this.currentAnimation.stop(),this.resumingFrom&&this.resumingFrom.currentAnimation&&this.resumingFrom.currentAnimation.stop(),this.pendingAnimation&&(Sn(this.pendingAnimation),this.pendingAnimation=void 0),this.pendingAnimation=Se.update(()=>{Us.hasAnimatedSinceResize=!0,this.currentAnimation=qS(0,Mm,{...s,onUpdate:a=>{this.mixTargetDelta(a),s.onUpdate&&s.onUpdate(a)},onComplete:()=>{s.onComplete&&s.onComplete(),this.completeAnimation()}}),this.resumingFrom&&(this.resumingFrom.currentAnimation=this.currentAnimation),this.pendingAnimation=void 0})}completeAnimation(){this.resumingFrom&&(this.resumingFrom.currentAnimation=void 0,this.resumingFrom.preserveOpacity=void 0);const s=this.getStack();s&&s.exitAnimationComplete(),this.resumingFrom=this.currentAnimation=this.animationValues=void 0,this.notifyListeners("animationComplete")}finishAnimation(){this.currentAnimation&&(this.mixTargetDelta&&this.mixTargetDelta(Mm),this.currentAnimation.stop()),this.completeAnimation()}applyTransformsToTarget(){const s=this.getLead();let{targetWithTransforms:a,target:l,layout:c,latestValues:u}=s;if(!(!a||!l||!c)){if(this!==s&&this.layout&&c&&i5(this.options.animationType,this.layout.layoutBox,c.layoutBox)){l=this.target||Ve();const d=St(this.layout.layoutBox.x);l.x.min=s.target.x.min,l.x.max=l.x.min+d;const p=St(this.layout.layoutBox.y);l.y.min=s.target.y.min,l.y.max=l.y.min+p}At(a,l),co(a,u),mi(this.projectionDeltaWithTransform,this.layoutCorrected,a,u)}}registerSharedNode(s,a){this.sharedNodes.has(s)||this.sharedNodes.set(s,new WS),this.sharedNodes.get(s).add(a);const c=a.options.initialPromotionConfig;a.promote({transition:c?c.transition:void 0,preserveFollowOpacity:c&&c.shouldPreserveFollowOpacity?c.shouldPreserveFollowOpacity(a):void 0})}isLead(){const s=this.getStack();return s?s.lead===this:!0}getLead(){var s;const{layoutId:a}=this.options;return a?((s=this.getStack())===null||s===void 0?void 0:s.lead)||this:this}getPrevLead(){var s;const{layoutId:a}=this.options;return a?(s=this.getStack())===null||s===void 0?void 0:s.prevLead:void 0}getStack(){const{layoutId:s}=this.options;if(s)return this.root.sharedNodes.get(s)}promote({needsReset:s,transition:a,preserveFollowOpacity:l}={}){const c=this.getStack();c&&c.promote(this,l),s&&(this.projectionDelta=void 0,this.needsReset=!0),a&&this.setOptions({transition:a})}relegate(){const s=this.getStack();return s?s.relegate(this):!1}resetRotation(){const{visualElement:s}=this.options;if(!s)return;let a=!1;const{latestValues:l}=s;if((l.rotate||l.rotateX||l.rotateY||l.rotateZ)&&(a=!0),!a)return;const c={};for(let u=0;u<Dm.length;u++){const d="rotate"+Dm[u];l[d]&&(c[d]=l[d],s.setStaticValue(d,0))}s.render();for(const u in c)s.setStaticValue(u,c[u]);s.scheduleRender()}getProjectionStyles(s){var a,l;if(!this.instance||this.isSVG)return;if(!this.isVisible)return ZS;const c={visibility:""},u=this.getTransformTemplate();if(this.needsReset)return this.needsReset=!1,c.opacity="",c.pointerEvents=Bs(s==null?void 0:s.pointerEvents)||"",c.transform=u?u(this.latestValues,""):"none",c;const d=this.getLead();if(!this.projectionDelta||!this.layout||!d.target){const x={};return this.options.layoutId&&(x.opacity=this.latestValues.opacity!==void 0?this.latestValues.opacity:1,x.pointerEvents=Bs(s==null?void 0:s.pointerEvents)||""),this.hasProjected&&!hr(this.latestValues)&&(x.transform=u?u({},""):"none",this.hasProjected=!1),x}const p=d.animationValues||d.latestValues;this.applyTransformsToTarget(),c.transform=Am(this.projectionDeltaWithTransform,this.treeScale,p),u&&(c.transform=u(p,c.transform));const{x:y,y:w}=this.projectionDelta;c.transformOrigin=`${y.origin*100}% ${w.origin*100}% 0`,d.animationValues?c.opacity=d===this?(l=(a=p.opacity)!==null&&a!==void 0?a:this.latestValues.opacity)!==null&&l!==void 0?l:1:this.preserveOpacity?this.latestValues.opacity:p.opacityExit:c.opacity=d===this?p.opacity!==void 0?p.opacity:"":p.opacityExit!==void 0?p.opacityExit:0;for(const x in Ca){if(p[x]===void 0)continue;const{correct:b,applyTo:g}=Ca[x],h=c.transform==="none"?p[x]:b(p[x],d);if(g){const m=g.length;for(let S=0;S<m;S++)c[g[S]]=h}else c[x]=h}return this.options.layoutId&&(c.pointerEvents=d===this?Bs(s==null?void 0:s.pointerEvents)||"":"none"),c}clearSnapshot(){this.resumeFrom=this.snapshot=void 0}resetTree(){this.root.nodes.forEach(s=>{var a;return(a=s.currentAnimation)===null||a===void 0?void 0:a.stop()}),this.root.nodes.forEach(Rm),this.root.sharedNodes.clear()}}}function e6(e){e.updateLayout()}function t6(e){var t;const n=((t=e.resumeFrom)===null||t===void 0?void 0:t.snapshot)||e.snapshot;if(e.isLead()&&e.layout&&n&&e.hasListeners("didUpdate")){const{layoutBox:r,measuredBox:o}=e.layout,{animationType:i}=e.options,s=n.source!==e.layout.source;i==="size"?Rt(d=>{const p=s?n.measuredBox[d]:n.layoutBox[d],y=St(p);p.min=r[d].min,p.max=p.min+y}):i5(i,n.layoutBox,r)&&Rt(d=>{const p=s?n.measuredBox[d]:n.layoutBox[d],y=St(r[d]);p.max=p.min+y,e.relativeTarget&&!e.currentAnimation&&(e.isProjectionDirty=!0,e.relativeTarget[d].max=e.relativeTarget[d].min+y)});const a=lo();mi(a,r,n.layoutBox);const l=lo();s?mi(l,e.applyTransform(o,!0),n.measuredBox):mi(l,r,n.layoutBox);const c=!n5(a);let u=!1;if(!e.resumeFrom){const d=e.getClosestProjectingParent();if(d&&!d.resumeFrom){const{snapshot:p,layout:y}=d;if(p&&y){const w=Ve();gi(w,n.layoutBox,p.layoutBox);const x=Ve();gi(x,r,y.layoutBox),r5(w,x)||(u=!0),d.options.layoutRoot&&(e.relativeTarget=x,e.relativeTargetOrigin=w,e.relativeParent=d)}}}e.notifyListeners("didUpdate",{layout:r,snapshot:n,delta:l,layoutDelta:a,hasLayoutChanged:c,hasRelativeTargetChanged:u})}else if(e.isLead()){const{onExitComplete:r}=e.options;r&&r()}e.options.transition=void 0}function n6(e){pr.totalNodes++,e.parent&&(e.isProjecting()||(e.isProjectionDirty=e.parent.isProjectionDirty),e.isSharedProjectionDirty||(e.isSharedProjectionDirty=Boolean(e.isProjectionDirty||e.parent.isProjectionDirty||e.parent.isSharedProjectionDirty)),e.isTransformDirty||(e.isTransformDirty=e.parent.isTransformDirty))}function r6(e){e.isProjectionDirty=e.isSharedProjectionDirty=e.isTransformDirty=!1}function o6(e){e.clearSnapshot()}function Rm(e){e.clearMeasurements()}function i6(e){e.isLayoutDirty=!1}function s6(e){const{visualElement:t}=e.options;t&&t.getProps().onBeforeLayoutMeasure&&t.notify("BeforeLayoutMeasure"),e.resetTransform()}function $m(e){e.finishAnimation(),e.targetDelta=e.relativeTarget=e.target=void 0,e.isProjectionDirty=!0}function a6(e){e.resolveTargetDelta()}function l6(e){e.calcProjection()}function c6(e){e.resetRotation()}function u6(e){e.removeLeadSnapshot()}function Lm(e,t,n){e.translate=Re(t.translate,0,n),e.scale=Re(t.scale,1,n),e.origin=t.origin,e.originPoint=t.originPoint}function Nm(e,t,n,r){e.min=Re(t.min,n.min,r),e.max=Re(t.max,n.max,r)}function d6(e,t,n,r){Nm(e.x,t.x,n.x,r),Nm(e.y,t.y,n.y,r)}function f6(e){return e.animationValues&&e.animationValues.opacityExit!==void 0}const h6={duration:.45,ease:[.4,0,.1,1]},_m=e=>typeof navigator!="undefined"&&navigator.userAgent.toLowerCase().includes(e),Fm=_m("applewebkit/")&&!_m("chrome/")?Math.round:_e;function zm(e){e.min=Fm(e.min),e.max=Fm(e.max)}function p6(e){zm(e.x),zm(e.y)}function i5(e,t,n){return e==="position"||e==="preserve-aspect"&&!Ku(Om(t),Om(n),.2)}const m6=o5({attachResizeListener:(e,t)=>mn(e,"resize",t),measureScroll:()=>({x:document.documentElement.scrollLeft||document.body.scrollLeft,y:document.documentElement.scrollTop||document.body.scrollTop}),checkIsScrollRoot:()=>!0}),gc={current:void 0},s5=o5({measureScroll:e=>({x:e.scrollLeft,y:e.scrollTop}),defaultParent:()=>{if(!gc.current){const e=new m6({});e.mount(window),e.setOptions({layoutScroll:!0}),gc.current=e}return gc.current},resetTransform:(e,t)=>{e.style.transform=t!==void 0?t:"none"},checkIsScrollRoot:e=>Boolean(window.getComputedStyle(e).position==="fixed")}),g6={pan:{Feature:TS},drag:{Feature:PS,ProjectionNode:s5,MeasureLayout:Jv}},y6=/var\((--[a-zA-Z0-9-_]+),? ?([a-zA-Z0-9 ()%#.,-]+)?\)/;function v6(e){const t=y6.exec(e);if(!t)return[,];const[,n,r]=t;return[n,r]}function qu(e,t,n=1){const[r,o]=v6(e);if(!r)return;const i=window.getComputedStyle(t).getPropertyValue(r);if(i){const s=i.trim();return jv(s)?parseFloat(s):s}else return Vu(o)?qu(o,t,n+1):o}function x6(e,{...t},n){const r=e.current;if(!(r instanceof Element))return{target:t,transitionEnd:n};n&&(n={...n}),e.values.forEach(o=>{const i=o.get();if(!Vu(i))return;const s=qu(i,r);s&&o.set(s)});for(const o in t){const i=t[o];if(!Vu(i))continue;const s=qu(i,r);!s||(t[o]=s,n||(n={}),n[o]===void 0&&(n[o]=i))}return{target:t,transitionEnd:n}}const w6=new Set(["width","height","top","left","right","bottom","x","y","translateX","translateY"]),a5=e=>w6.has(e),b6=e=>Object.keys(e).some(a5),Vm=e=>e===Lr||e===ne,jm=(e,t)=>parseFloat(e.split(", ")[t]),Bm=(e,t)=>(n,{transform:r})=>{if(r==="none"||!r)return 0;const o=r.match(/^matrix3d\((.+)\)$/);if(o)return jm(o[1],t);{const i=r.match(/^matrix\((.+)\)$/);return i?jm(i[1],e):0}},C6=new Set(["x","y","z"]),S6=Qi.filter(e=>!C6.has(e));function k6(e){const t=[];return S6.forEach(n=>{const r=e.getValue(n);r!==void 0&&(t.push([n,r.get()]),r.set(n.startsWith("scale")?1:0))}),t.length&&e.render(),t}const Oo={width:({x:e},{paddingLeft:t="0",paddingRight:n="0"})=>e.max-e.min-parseFloat(t)-parseFloat(n),height:({y:e},{paddingTop:t="0",paddingBottom:n="0"})=>e.max-e.min-parseFloat(t)-parseFloat(n),top:(e,{top:t})=>parseFloat(t),left:(e,{left:t})=>parseFloat(t),bottom:({y:e},{top:t})=>parseFloat(t)+(e.max-e.min),right:({x:e},{left:t})=>parseFloat(t)+(e.max-e.min),x:Bm(4,13),y:Bm(5,14)};Oo.translateX=Oo.x;Oo.translateY=Oo.y;const P6=(e,t,n)=>{const r=t.measureViewportBox(),o=t.current,i=getComputedStyle(o),{display:s}=i,a={};s==="none"&&t.setStaticValue("display",e.display||"block"),n.forEach(c=>{a[c]=Oo[c](r,i)}),t.render();const l=t.measureViewportBox();return n.forEach(c=>{const u=t.getValue(c);u&&u.jump(a[c]),e[c]=Oo[c](l,i)}),e},T6=(e,t,n={},r={})=>{t={...t},r={...r};const o=Object.keys(t).filter(a5);let i=[],s=!1;const a=[];if(o.forEach(l=>{const c=e.getValue(l);if(!e.hasValue(l))return;let u=n[l],d=Uo(u);const p=t[l];let y;if(ka(p)){const w=p.length,x=p[0]===null?1:0;u=p[x],d=Uo(u);for(let b=x;b<w&&p[b]!==null;b++)y?vl(Uo(p[b])===y):y=Uo(p[b])}else y=Uo(p);if(d!==y)if(Vm(d)&&Vm(y)){const w=c.get();typeof w=="string"&&c.set(parseFloat(w)),typeof p=="string"?t[l]=parseFloat(p):Array.isArray(p)&&y===ne&&(t[l]=p.map(parseFloat))}else(d==null?void 0:d.transform)&&(y==null?void 0:y.transform)&&(u===0||p===0)?u===0?c.set(y.transform(u)):t[l]=d.transform(p):(s||(i=k6(e),s=!0),a.push(l),r[l]=r[l]!==void 0?r[l]:t[l],c.jump(p))}),a.length){const l=a.indexOf("height")>=0?window.pageYOffset:null,c=P6(t,e,a);return i.length&&i.forEach(([u,d])=>{e.getValue(u).set(d)}),e.render(),fl&&l!==null&&window.scrollTo({top:l}),{target:c,transitionEnd:r}}else return{target:t,transitionEnd:r}};function E6(e,t,n,r){return b6(t)?T6(e,t,n,r):{target:t,transitionEnd:r}}const I6=(e,t,n,r)=>{const o=x6(e,t,r);return t=o.target,r=o.transitionEnd,E6(e,t,n,r)},Zu={current:null},l5={current:!1};function O6(){if(l5.current=!0,!!fl)if(window.matchMedia){const e=window.matchMedia("(prefers-reduced-motion)"),t=()=>Zu.current=e.matches;e.addListener(t),t()}else Zu.current=!1}function A6(e,t,n){const{willChange:r}=t;for(const o in t){const i=t[o],s=n[o];if(vt(i))e.addValue(o,i),Ia(r)&&r.add(o);else if(vt(s))e.addValue(o,Io(i,{owner:e})),Ia(r)&&r.remove(o);else if(s!==i)if(e.hasValue(o)){const a=e.getValue(o);!a.hasAnimated&&a.set(i)}else{const a=e.getStaticValue(o);e.addValue(o,Io(a!==void 0?a:i,{owner:e}))}}for(const o in n)t[o]===void 0&&e.removeValue(o);return t}const Um=new WeakMap,c5=Object.keys(Vi),D6=c5.length,Hm=["AnimationStart","AnimationComplete","Update","BeforeLayoutMeasure","LayoutMeasure","LayoutAnimationStart","LayoutAnimationComplete"],M6=Cf.length;class R6{constructor({parent:t,props:n,presenceContext:r,reducedMotionConfig:o,visualState:i},s={}){this.current=null,this.children=new Set,this.isVariantNode=!1,this.isControllingVariants=!1,this.shouldReduceMotion=null,this.values=new Map,this.features={},this.valueSubscriptions=new Map,this.prevMotionValues={},this.events={},this.propEventSubscriptions={},this.notifyUpdate=()=>this.notify("Update",this.latestValues),this.render=()=>{!this.current||(this.triggerBuild(),this.renderInstance(this.current,this.renderState,this.props.style,this.projection))},this.scheduleRender=()=>Se.render(this.render,!1,!0);const{latestValues:a,renderState:l}=i;this.latestValues=a,this.baseTarget={...a},this.initialValues=n.initial?{...a}:{},this.renderState=l,this.parent=t,this.props=n,this.presenceContext=r,this.depth=t?t.depth+1:0,this.reducedMotionConfig=o,this.options=s,this.isControllingVariants=pl(n),this.isVariantNode=Gy(n),this.isVariantNode&&(this.variantChildren=new Set),this.manuallyAnimateOnMount=Boolean(t&&t.current);const{willChange:c,...u}=this.scrapeMotionValuesFromProps(n,{});for(const d in u){const p=u[d];a[d]!==void 0&&vt(p)&&(p.set(a[d],!1),Ia(c)&&c.add(d))}}scrapeMotionValuesFromProps(t,n){return{}}mount(t){this.current=t,Um.set(t,this),this.projection&&!this.projection.instance&&this.projection.mount(t),this.parent&&this.isVariantNode&&!this.isControllingVariants&&(this.removeFromVariantTree=this.parent.addVariantChild(this)),this.values.forEach((n,r)=>this.bindToMotionValue(r,n)),l5.current||O6(),this.shouldReduceMotion=this.reducedMotionConfig==="never"?!1:this.reducedMotionConfig==="always"?!0:Zu.current,this.parent&&this.parent.children.add(this),this.update(this.props,this.presenceContext)}unmount(){Um.delete(this.current),this.projection&&this.projection.unmount(),Sn(this.notifyUpdate),Sn(this.render),this.valueSubscriptions.forEach(t=>t()),this.removeFromVariantTree&&this.removeFromVariantTree(),this.parent&&this.parent.children.delete(this);for(const t in this.events)this.events[t].clear();for(const t in this.features)this.features[t].unmount();this.current=null}bindToMotionValue(t,n){const r=$r.has(t),o=n.on("change",s=>{this.latestValues[t]=s,this.props.onUpdate&&Se.update(this.notifyUpdate,!1,!0),r&&this.projection&&(this.projection.isTransformDirty=!0)}),i=n.on("renderRequest",this.scheduleRender);this.valueSubscriptions.set(t,()=>{o(),i()})}sortNodePosition(t){return!this.current||!this.sortInstanceNodePosition||this.type!==t.type?0:this.sortInstanceNodePosition(this.current,t.current)}loadFeatures({children:t,...n},r,o,i){let s,a;for(let l=0;l<D6;l++){const c=c5[l],{isEnabled:u,Feature:d,ProjectionNode:p,MeasureLayout:y}=Vi[c];p&&(s=p),u(n)&&(!this.features[c]&&d&&(this.features[c]=new d(this)),y&&(a=y))}if((this.type==="html"||this.type==="svg")&&!this.projection&&s){this.projection=new s(this.latestValues,this.parent&&this.parent.projection);const{layoutId:l,layout:c,drag:u,dragConstraints:d,layoutScroll:p,layoutRoot:y}=n;this.projection.setOptions({layoutId:l,layout:c,alwaysMeasureLayout:Boolean(u)||d&&so(d),visualElement:this,scheduleRender:()=>this.scheduleRender(),animationType:typeof c=="string"?c:"both",initialPromotionConfig:i,layoutScroll:p,layoutRoot:y})}return a}updateFeatures(){for(const t in this.features){const n=this.features[t];n.isMounted?n.update():(n.mount(),n.isMounted=!0)}}triggerBuild(){this.build(this.renderState,this.latestValues,this.options,this.props)}measureViewportBox(){return this.current?this.measureInstanceViewportBox(this.current,this.props):Ve()}getStaticValue(t){return this.latestValues[t]}setStaticValue(t,n){this.latestValues[t]=n}makeTargetAnimatable(t,n=!0){return this.makeTargetAnimatableFromInstance(t,this.props,n)}update(t,n){(t.transformTemplate||this.props.transformTemplate)&&this.scheduleRender(),this.prevProps=this.props,this.props=t,this.prevPresenceContext=this.presenceContext,this.presenceContext=n;for(let r=0;r<Hm.length;r++){const o=Hm[r];this.propEventSubscriptions[o]&&(this.propEventSubscriptions[o](),delete this.propEventSubscriptions[o]);const i=t["on"+o];i&&(this.propEventSubscriptions[o]=this.on(o,i))}this.prevMotionValues=A6(this,this.scrapeMotionValuesFromProps(t,this.prevProps),this.prevMotionValues),this.handleChildMotionValue&&this.handleChildMotionValue()}getProps(){return this.props}getVariant(t){return this.props.variants?this.props.variants[t]:void 0}getDefaultTransition(){return this.props.transition}getTransformPagePoint(){return this.props.transformPagePoint}getClosestVariantNode(){return this.isVariantNode?this:this.parent?this.parent.getClosestVariantNode():void 0}getVariantContext(t=!1){if(t)return this.parent?this.parent.getVariantContext():void 0;if(!this.isControllingVariants){const r=this.parent?this.parent.getVariantContext()||{}:{};return this.props.initial!==void 0&&(r.initial=this.props.initial),r}const n={};for(let r=0;r<M6;r++){const o=Cf[r],i=this.props[o];(zi(i)||i===!1)&&(n[o]=i)}return n}addVariantChild(t){const n=this.getClosestVariantNode();if(n)return n.variantChildren&&n.variantChildren.add(t),()=>n.variantChildren.delete(t)}addValue(t,n){n!==this.values.get(t)&&(this.removeValue(t),this.bindToMotionValue(t,n)),this.values.set(t,n),this.latestValues[t]=n.get()}removeValue(t){this.values.delete(t);const n=this.valueSubscriptions.get(t);n&&(n(),this.valueSubscriptions.delete(t)),delete this.latestValues[t],this.removeValueFromRenderState(t,this.renderState)}hasValue(t){return this.values.has(t)}getValue(t,n){if(this.props.values&&this.props.values[t])return this.props.values[t];let r=this.values.get(t);return r===void 0&&n!==void 0&&(r=Io(n,{owner:this}),this.addValue(t,r)),r}readValue(t){var n;return this.latestValues[t]!==void 0||!this.current?this.latestValues[t]:(n=this.getBaseTargetFromProps(this.props,t))!==null&&n!==void 0?n:this.readValueFromInstance(this.current,t,this.options)}setBaseTarget(t,n){this.baseTarget[t]=n}getBaseTarget(t){var n;const{initial:r}=this.props,o=typeof r=="string"||typeof r=="object"?(n=Af(this.props,r))===null||n===void 0?void 0:n[t]:void 0;if(r&&o!==void 0)return o;const i=this.getBaseTargetFromProps(this.props,t);return i!==void 0&&!vt(i)?i:this.initialValues[t]!==void 0&&o===void 0?void 0:this.baseTarget[t]}on(t,n){return this.events[t]||(this.events[t]=new Vf),this.events[t].add(n)}notify(t,...n){this.events[t]&&this.events[t].notify(...n)}}class u5 extends R6{sortInstanceNodePosition(t,n){return t.compareDocumentPosition(n)&2?1:-1}getBaseTargetFromProps(t,n){return t.style?t.style[n]:void 0}removeValueFromRenderState(t,{vars:n,style:r}){delete n[t],delete r[t]}makeTargetAnimatableFromInstance({transition:t,transitionEnd:n,...r},{transformValues:o},i){let s=HC(r,t||{},this);if(o&&(n&&(n=o(n)),r&&(r=o(r)),s&&(s=o(s))),i){BC(this,r,s);const a=I6(this,r,s,n);n=a.transitionEnd,r=a.target}return{transition:t,transitionEnd:n,...r}}}function $6(e){return window.getComputedStyle(e)}class L6 extends u5{constructor(){super(...arguments),this.type="html"}readValueFromInstance(t,n){if($r.has(n)){const r=Lf(n);return r&&r.default||0}else{const r=$6(t),o=(Xy(n)?r.getPropertyValue(n):r[n])||0;return typeof o=="string"?o.trim():o}}measureInstanceViewportBox(t,{transformPagePoint:n}){return Xv(t,n)}build(t,n,r,o){Pf(t,n,r,o.transformTemplate)}scrapeMotionValuesFromProps(t,n){return Of(t,n)}handleChildMotionValue(){this.childSubscription&&(this.childSubscription(),delete this.childSubscription);const{children:t}=this.props;vt(t)&&(this.childSubscription=t.on("change",n=>{this.current&&(this.current.textContent=`${n}`)}))}renderInstance(t,n,r,o){nv(t,n,r,o)}}class N6 extends u5{constructor(){super(...arguments),this.type="svg",this.isSVGTag=!1}getBaseTargetFromProps(t,n){return t[n]}readValueFromInstance(t,n){if($r.has(n)){const r=Lf(n);return r&&r.default||0}return n=rv.has(n)?n:wf(n),t.getAttribute(n)}measureInstanceViewportBox(){return Ve()}scrapeMotionValuesFromProps(t,n){return iv(t,n)}build(t,n,r,o){Ef(t,n,r,this.isSVGTag,o.transformTemplate)}renderInstance(t,n,r,o){ov(t,n,r,o)}mount(t){this.isSVGTag=If(t.tagName),super.mount(t)}}const _6=(e,t)=>kf(e)?new N6(t,{enableHardwareAcceleration:!1}):new L6(t,{enableHardwareAcceleration:!0}),F6={layout:{ProjectionNode:s5,MeasureLayout:Jv}},z6={...iS,...E3,...g6,...F6},bl=N4((e,t)=>p3(e,t,z6,_6));function d5(){const e=v.exports.useRef(!1);return xf(()=>(e.current=!0,()=>{e.current=!1}),[]),e}function V6(){const e=d5(),[t,n]=v.exports.useState(0),r=v.exports.useCallback(()=>{e.current&&n(t+1)},[t]);return[v.exports.useCallback(()=>Se.postRender(r),[r]),t]}class j6 extends v.exports.Component{getSnapshotBeforeUpdate(t){const n=this.props.childRef.current;if(n&&t.isPresent&&!this.props.isPresent){const r=this.props.sizeRef.current;r.height=n.offsetHeight||0,r.width=n.offsetWidth||0,r.top=n.offsetTop,r.left=n.offsetLeft}return null}componentDidUpdate(){}render(){return this.props.children}}function B6({children:e,isPresent:t}){const n=v.exports.useId(),r=v.exports.useRef(null),o=v.exports.useRef({width:0,height:0,top:0,left:0});return v.exports.useInsertionEffect(()=>{const{width:i,height:s,top:a,left:l}=o.current;if(t||!r.current||!i||!s)return;r.current.dataset.motionPopId=n;const c=document.createElement("style");return document.head.appendChild(c),c.sheet&&c.sheet.insertRule(`
          [data-motion-pop-id="${n}"] {
            position: absolute !important;
            width: ${i}px !important;
            height: ${s}px !important;
            top: ${a}px !important;
            left: ${l}px !important;
          }
        `),()=>{document.head.removeChild(c)}},[t]),v.exports.createElement(j6,{isPresent:t,childRef:r,sizeRef:o},v.exports.cloneElement(e,{ref:r}))}const yc=({children:e,initial:t,isPresent:n,onExitComplete:r,custom:o,presenceAffectsLayout:i,mode:s})=>{const a=sv(U6),l=v.exports.useId(),c=v.exports.useMemo(()=>({id:l,initial:t,isPresent:n,custom:o,onExitComplete:u=>{a.set(u,!0);for(const d of a.values())if(!d)return;r&&r()},register:u=>(a.set(u,!1),()=>a.delete(u))}),i?void 0:[n]);return v.exports.useMemo(()=>{a.forEach((u,d)=>a.set(d,!1))},[n]),v.exports.useEffect(()=>{!n&&!a.size&&r&&r()},[n]),s==="popLayout"&&(e=v.exports.createElement(B6,{isPresent:n},e)),v.exports.createElement(dl.Provider,{value:c},e)};function U6(){return new Map}function H6(e){return v.exports.useEffect(()=>()=>e(),[])}const mr=e=>e.key||"";function W6(e,t){e.forEach(n=>{const r=mr(n);t.set(r,n)})}function G6(e){const t=[];return v.exports.Children.forEach(e,n=>{v.exports.isValidElement(n)&&t.push(n)}),t}const f5=({children:e,custom:t,initial:n=!0,onExitComplete:r,exitBeforeEnter:o,presenceAffectsLayout:i=!0,mode:s="sync"})=>{vl(!o);const a=v.exports.useContext(Sf).forceRender||V6()[0],l=d5(),c=G6(e);let u=c;const d=v.exports.useRef(new Map).current,p=v.exports.useRef(u),y=v.exports.useRef(new Map).current,w=v.exports.useRef(!0);if(xf(()=>{w.current=!1,W6(c,y),p.current=u}),H6(()=>{w.current=!0,y.clear(),d.clear()}),w.current)return v.exports.createElement(v.exports.Fragment,null,u.map(h=>v.exports.createElement(yc,{key:mr(h),isPresent:!0,initial:n?void 0:!1,presenceAffectsLayout:i,mode:s},h)));u=[...u];const x=p.current.map(mr),b=c.map(mr),g=x.length;for(let h=0;h<g;h++){const m=x[h];b.indexOf(m)===-1&&!d.has(m)&&d.set(m,void 0)}return s==="wait"&&d.size&&(u=[]),d.forEach((h,m)=>{if(b.indexOf(m)!==-1)return;const S=y.get(m);if(!S)return;const E=x.indexOf(m);let T=h;if(!T){const I=()=>{d.delete(m);const O=Array.from(y.keys()).filter(L=>!b.includes(L));if(O.forEach(L=>y.delete(L)),p.current=c.filter(L=>{const _=mr(L);return _===m||O.includes(_)}),!d.size){if(l.current===!1)return;a(),r&&r()}};T=v.exports.createElement(yc,{key:mr(S),isPresent:!1,onExitComplete:I,custom:t,presenceAffectsLayout:i,mode:s},S),d.set(m,T)}u.splice(E,0,T)}),u=u.map(h=>{const m=h.key;return d.has(m)?h:v.exports.createElement(yc,{key:mr(h),isPresent:!0,presenceAffectsLayout:i,mode:s},h)}),v.exports.createElement(v.exports.Fragment,null,d.size?u:u.map(h=>v.exports.cloneElement(h)))},K6=v.exports.createContext(null),Y6=({children:e})=>{const[t,n]=v.exports.useState(!1),r=cl();return ot("setVisible",o=>{typeof o=="string"?(n(!0),r("/"+o)):n(o)}),v.exports.useEffect(()=>{if(!t)return;const o=i=>{["Escape"].includes(i.code)&&(pt()?n(!t):Oe("hideFrame"))};return window.addEventListener("keydown",o),()=>{window.removeEventListener("keydown",o)}},[t]),v.exports.useEffect(()=>{pt()&&n(!0)},[]),f(K6.Provider,{value:{visible:t,setVisible:n},children:f(f5,{children:t&&f(bl.div,{initial:{opacity:0},animate:{opacity:t?1:0},exit:{opacity:0},transition:{duration:.3},style:{position:"fixed",top:0,right:0,width:"100vw",height:"100vh"},children:e})})})},nn=e=>Wm[e]?Wm[e]:pt()?e==="no-image"?"data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjQiIGhlaWdodD0iNjQiIHZpZXdCb3g9IjAgMCA2NCA2NCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iNjQiIGhlaWdodD0iNjQiIHJ4PSI4IiBmaWxsPSIjMzMzIi8+PHBhdGggZD0iTTIwIDIwTDQ0IDQ0TTIwIDQ0TDQ0IDIwIiBzdHJva2U9IiM2NjYiIHN0cm9rZS13aWR0aD0iNCIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIi8+PC9zdmc+":`https://via.placeholder.com/64x64/333333/666666?text=${encodeURIComponent(e)}`:`https://santaimagens.roleplayrp.com/img/inventory/${e}.png`,Q6={hotbar:"requestHotbar",main:"requestInventory",trunk:"requestTrunk",property:"requestProperty",inspect:"requestInspect",shop:"requestShop",ground:"requestDrop",chest:"requestChest",preview:"requestPreview"},X6=["chest","main","inspect","property","trunk"],q6=["inspect"],Z6={main:"updateSlotMain",trunk:"updateSlotTrunk",chest:"updateSlotChest",property:"updateSlotProperty",inspect:"updateSlotInspect",ground:"updateSlotGround",hotbar:"updateSlotHotbar",preview:"updateSlotPreview",shop:"updateSlotShop"},J6={main:"pickupSlotMain",trunk:"pickupSlotTrunk",chest:"pickupSlotChest",property:"pickupSlotProperty",inspect:"pickupSlotInspect",ground:"pickupSlotGround",hotbar:"pickupSlotHotbar",preview:"pickupSlotPreview",shop:"pickupSlotShop"},ek={main:"dropSlotMain",trunk:"dropSlotTrunk",chest:"dropSlotChest",property:"dropSlotProperty",inspect:"dropSlotInspect",ground:"dropSlotGround",hotbar:"dropSlotHotbar",preview:"dropSlotPreview",shop:"dropSlotShop"},tk={main:"requestUpgradeInventory",trunk:"requestUpgradeTrunk",chest:"requestUpgradeChest",property:"requestUpgradeProperty",inspect:"requestUpgradeInspect",ground:"requestUpgradeGround",hotbar:"requestUpgradeHotbar",preview:"requestUpgradePreview",shop:"requestUpgradeShop"},nk={burgershot1:"Rel\xF3gio de Ouro Antigo",burgershot2:"Colar de P\xE9rolas",burgershot3:"Brinco de Diamante",burgershot4:"Anel de Noivado Velho",pizzathis1:"Medalh\xE3o de Fam\xEDlia",pizzathis2:"Alian\xE7a Dourada",pizzathis3:"Broche Antigo",pizzathis4:"Moeda Mortu\xE1ria",uwucoffee1:"Osso Humano",uwucoffee2:"Cr\xE2nio Velho",uwucoffee3:"Olho Apodrecido",uwucoffee4:"C\xE9rebro Podre",beanmachine1:"M\xE3o Esquel\xE9tica",beanmachine2:"Dente Amarelado",beanmachine3:"Fragmento de Caix\xE3o",beanmachine4:"Terra de Cova"},Wm={burgershot1:"https://santaimagens.roleplayrp.com/img/inventory/relogio_ouro.png",burgershot2:"https://santaimagens.roleplayrp.com/img/inventory/colar_perolas.png",burgershot3:"https://santaimagens.roleplayrp.com/img/inventory/brinco_diamante.png",burgershot4:"https://santaimagens.roleplayrp.com/img/inventory/anel_noivado.png",pizzathis1:"https://santaimagens.roleplayrp.com/img/inventory/medalhao_familia.png",pizzathis2:"https://santaimagens.roleplayrp.com/img/inventory/alianca_dourada.png",pizzathis3:"https://santaimagens.roleplayrp.com/img/inventory/broche_antigo.png",pizzathis4:"https://santaimagens.roleplayrp.com/img/inventory/moeda_mortuaria.png",uwucoffee1:"https://santaimagens.roleplayrp.com/img/inventory/osso_humano.png",uwucoffee2:"https://santaimagens.roleplayrp.com/img/inventory/cranio_velho.png",uwucoffee3:"https://santaimagens.roleplayrp.com/img/inventory/olho_apodrecido.png",uwucoffee4:"https://santaimagens.roleplayrp.com/img/inventory/cerebro_podre.png",beanmachine1:"https://santaimagens.roleplayrp.com/img/inventory/mao_esqueletica.png",beanmachine2:"https://santaimagens.roleplayrp.com/img/inventory/dente_amarelado.png",beanmachine3:"https://santaimagens.roleplayrp.com/img/inventory/fragmento_caixao.png",beanmachine4:"https://santaimagens.roleplayrp.com/img/inventory/terra_cova.png"},h5=(e,t)=>nk[e]||t,Nt=e=>(e==null?void 0:e.index)!=null||(e==null?void 0:e.amount)!==void 0||(e==null?void 0:e.amount)<=0,rk=async(e,t,n,r,o=1)=>{var d,p,y,w;if(!n||!r)return{newMainInventory:n,newSecondaryInventory:r};if(!e.item)return{newMainInventory:n,newSecondaryInventory:r};if(e.type===t.type&&!X6.includes(t.type))return{newMainInventory:n,newSecondaryInventory:r};if(e.item.slot===t.slot&&e.type===t.type)return{newMainInventory:n,newSecondaryInventory:r};const i=e.type===n.type?n:r,s=t.type===n.type?n:r,a=i.items.find(x=>{var b;return x.slot===((b=e.item)==null?void 0:b.slot)}),l=(d=a==null?void 0:a.amount)!=null?d:0,c=o===0?l:o,u=s.items.find(x=>x.slot===t.slot);if(!Nt(a))return{newMainInventory:n,newSecondaryInventory:r};if(i.type===s.type){if(Oe(Z6[i.type],{item:a.key,slot:a.slot,target:t.slot,amount:c}),!Nt(u))if(c>=l){const x=i.items.findIndex(S=>S.slot===a.slot),b=[...i.items];b.splice(x,1);const g={...a,slot:t.slot};b.push(g);const h=i.type==="main"?{...i,items:b}:n,m=i.type==="main"?r:{...i,items:b};return{newMainInventory:h,newSecondaryInventory:m}}else{const x={...a,amount:l-c},b={...a,amount:c,slot:t.slot},g=i.items.map(S=>S.slot===a.slot?x:S);g.push(b);const h=i.type==="main"?{...i,items:g}:n,m=i.type==="main"?r:{...i,items:g};return{newMainInventory:h,newSecondaryInventory:m}}if(a.index!==u.index){const x={...a,slot:t.slot},b={...u,slot:a.slot},g=i.items.map(S=>S.slot===a.slot?b:S.slot===t.slot?x:S),h=i.type==="main"?{...i,items:g}:n,m=i.type==="main"?r:{...i,items:g};return{newMainInventory:h,newSecondaryInventory:m}}else if(c>=l){const x=i.items.map(h=>{var m;return h.slot===a.slot?null:h.slot===t.slot?{...h,amount:((m=u.amount)!=null?m:0)+l}:h}).filter(Boolean),b=i.type==="main"?{...i,items:x}:n,g=i.type==="main"?r:{...i,items:x};return{newMainInventory:b,newSecondaryInventory:g}}else{const x={...a,amount:l-c},b={...u,amount:((p=u.amount)!=null?p:0)+c},g=i.items.map(S=>S.slot===a.slot?x:S.slot===t.slot?b:S),h=i.type==="main"?{...i,items:g}:n,m=i.type==="main"?r:{...i,items:g};return{newMainInventory:h,newSecondaryInventory:m}}}else{if(i.type==="main"){if(q6.includes(s.type))return{newMainInventory:n,newSecondaryInventory:r};Oe(ek[s.type],{item:a.key,slot:a.slot,target:t.slot,amount:c})}else Oe(J6[i.type],{id:a.id,item:a.key,slot:a.slot,target:t.slot,amount:c});if(!Nt(u))if(c>=l){const x=i.items.findIndex(T=>T.slot===a.slot),b=[...i.items];b.splice(x,1);const g={...a,slot:t.slot},h={...i,items:b},m={...s,items:[...s.items,g]},S=h.type==="main"?h:m,E=h.type==="main"?m:h;return{newMainInventory:S,newSecondaryInventory:E}}else{const x={...a,amount:l-c},b={...a,amount:c,slot:t.slot},g=i.items.map(T=>T.slot===a.slot?x:T),h={...i,items:g},m={...s,items:[...s.items,b]},S=h.type==="main"?h:m,E=h.type==="main"?m:h;return{newMainInventory:S,newSecondaryInventory:E}}if(a.index!==u.index){const x={...a,slot:t.slot},b={...u,slot:a.slot},g=i.items.map(I=>I.slot===a.slot?b:I),h=s.items.map(I=>I.slot===u.slot?x:I),m={...i,items:g},S={...s,items:h},E=m.type==="main"?m:S,T=m.type==="main"?S:m;return{newMainInventory:E,newSecondaryInventory:T}}else if(c>=l){const x=i.items.filter(T=>T.slot!==a.slot),b={...u,amount:((y=u.amount)!=null?y:0)+c,slot:t.slot},g=s.items.map(T=>T.slot===u.slot?b:T),h={...i,items:x},m={...s,items:g},S=h.type==="main"?h:m,E=h.type==="main"?m:h;return{newMainInventory:S,newSecondaryInventory:E}}else{const x={...a,amount:l-c},b={...u,amount:((w=u.amount)!=null?w:0)+c},g=i.items.map(I=>I.slot===a.slot?x:I),h=s.items.map(I=>I.slot===u.slot?b:I),m={...i,items:g},S={...s,items:h},E=m.type==="main"?m:S,T=m.type==="main"?S:m;return{newMainInventory:E,newSecondaryInventory:T}}}},ok=async(e,t,n,r,o=1)=>{var u;if(e.type==="shop")return Oe("useItemShop",{...e,item:{...e.item,amount:o}}),{newMainInventory:n,newSecondaryInventory:r};if(!e.item)return{newMainInventory:n,newSecondaryInventory:r};const i=n.items.find(d=>{var p;return d.slot===((p=e.item)==null?void 0:p.slot)}),s=(u=i==null?void 0:i.amount)!=null?u:0,a={...i,amount:e.item.type==="Us\xE1vel"?s-o:s},l=n.items.map(d=>d.slot===(i==null?void 0:i.slot)?a:d),c={...n,items:l};switch(t){case"delivery":Oe("deliverItem",{...e,item:{...e.item,amount:o}});break;case"destruct":Oe("destructItem",{...e,item:{...e.item,amount:o}});break;case"send":Oe("sendItem",{...e,item:{...e.item,amount:o}});break;case"use":Oe("useItem",{...e,item:{...e.item,amount:o}});break}return{newMainInventory:c,newSecondaryInventory:r}},jf=(e,t)=>{const n=86400*e;if(n<=0)return 0;const r=(n-t)/n*100;return Math.min(Math.max(r,0),100)},ik=({days:e,durability:t,Durability:n})=>{const r=t!=null?t:n;if(r===void 0||!e)return"Sem validade";const o=86400*e,i=Math.max(0,Math.floor((o-r)/3600)),s=Math.floor(i/24);return s>0?`${s}d`:`${i}h`},p5=(e,t)=>{const n=jf(e,t);return n>=75?"#26A751":n>=25&&n<75?"#E8C547":n>=0&&n<25?"#E84F47":"transparent"},sk=(e,t)=>{if(e>=1){const r=Math.floor(e);return`${r} ${r>1?t("days"):t("day")}`}const n=Math.round(e*24*60);return n>=60?`${Math.floor(n/60)}h`:`${n}min`},ak=(e,t)=>{if(!t||t<=0)return 0;const n=e/t*100;return Math.min(Math.max(n,0),100)},lk=(e,t)=>{const n=ak(e,t);return n>=75?"#26A751":n>=25&&n<75?"#E8C547":n>0&&n<25?"#E84F47":"transparent"};function Bf(e,t=1){const n=[{value:1,symbol:""},{value:1e3,symbol:"K"},{value:1e6,symbol:"M"},{value:1e9,symbol:"B"},{value:1e12,symbol:"T"},{value:1e15,symbol:"P"},{value:1e18,symbol:"E"}],r=/\.0+$|(\.[0-9]*[1-9])0+$/,o=n.slice().reverse().find(function(i){return e>=i.value});return o?(e/o.value).toFixed(t).replace(r,"")+o.symbol:"0"}function ck(e,t=1){const n=[{value:1,symbol:"x"},{value:1e3,symbol:"K"},{value:1e6,symbol:"M"},{value:1e9,symbol:"B"},{value:1e12,symbol:"T"},{value:1e15,symbol:"P"},{value:1e18,symbol:"E"}],r=/\.0+$|(\.[0-9]*[1-9])0+$/,o=n.slice().reverse().find(function(i){return e>=i.value});return o?(e/o.value).toFixed(t).replace(r,"")+o.symbol:"0"}function uk(e,t=1){const n=[{value:1,symbol:"g"},{value:1e3,symbol:"kg"},{value:1e6,symbol:"t"},{value:1e9,symbol:"kt"},{value:1e12,symbol:"Mt"},{value:1e15,symbol:"Gt"},{value:1e18,symbol:"Tt"}],r=/\.0+$|(\.[0-9]*[1-9])0+$/,o=n.slice().reverse().find(function(i){return e>=i.value});return o?(e/o.value).toFixed(t).replace(r,"")+o.symbol:e.toFixed(1)+"kg"}function Uf(e){return parseInt(e.toString()).toString().replace(/\B(?=(\d{3})+(?!\d))/g,".")}function Ao(e){return parseInt(e.toString()).toString().replace(/\B(?=(\d{3})+(?!\d))/g,".")}function dk({index:e,amount:t}){switch(e){case"dollars":return Uf(t!=null?t:0);default:return Ao(t!=null?t:0)+"x"}}const vc=async e=>{const t=await Oe(Q6[e],[],{items:e!=="shop"?[{days:.083,item:"energetico-1773597193-1774029193",slot:1,durability:434823,weight:.25,economy:1e3,type:"Us\xE1vel",name:"Energy Drink",class:"Comida",amount:1,premium:!1,desc:"Item that increases movement speed.",key:"energetico-1773597193-1774029193",index:"energetico"},{days:1,item:"WEAPON_MINIGUN_AMMO",slot:2,durability:0,weight:.03,economy:30,type:"Muni\xE7\xE3o",name:"Minigun Ammo",class:"Armas",amount:300,premium:!0,desc:"Ammunition used for the minigun",key:"WEAPON_MINIGUN_AMMO",index:"WEAPON_MINIGUN_AMMO"},{days:1,item:"identity-1773597193",slot:3,durability:0,weight:.15,economy:5e3,type:"Comum",name:"Passport",class:"Utilitarios",amount:1,premium:!1,desc:"Passport for identification",key:"identity-1773597193",index:"identity"},{days:7,item:"WEAPON_MINIGUN-1774029253",slot:4,durability:2763,weight:3.75,economy:775,type:"Armamento",name:"Minigun",class:"Armas",amount:1,premium:!1,desc:"RPG weapon",key:"WEAPON_MINIGUN-1774029253",index:"WEAPON_MINIGUN"},{days:7,item:"WEAPON_MINIGUN-1773597193-1774029193",slot:5,durability:434823,weight:3.75,economy:775,type:"Armamento",name:"Minigun",class:"Armas",amount:1,premium:!1,desc:"RPG weapon",key:"WEAPON_MINIGUN-1773597193-1774029193",index:"WEAPON_MINIGUN"},{days:7,item:"WEAPON_MINIGUN-1616257944",slot:6,weight:3.75,economy:775,class:"Armas",type:"Armamento",name:"Minigun",premium:!1,amount:1,desc:"RPG weapon",index:"WEAPON_MINIGUN",key:"WEAPON_MINIGUN-1616257944",durability:157774072},{desc:"Passport for identification",economy:5e3,days:1,item:"identity-1269",slot:7,durability:0,weight:.15,class:"Utilitarios",type:"Comum",index:"identity",premium:!1,amount:1,key:"identity-1269",name:"Passport"},{days:1,index:"dollars",name:"Dollars",amount:5e3,max:1,weight:.1,slot:13,key:"dollars",desc:"Money"}]:[{weight:0,economy:500,key:"patrickhat",slot:1,premium:!1,index:"patrickhat",desc:"Colecion\xE1vel exclusivo do VIP St. Patrick.",price:0,name:"Chap\xE9u de St. Patrick",amount:1},{weight:0,economy:425,key:"pintinhopascoa",slot:2,premium:!1,index:"pintinhopascoa",desc:"Item colecion\xE1vel do evento de P\xE1scoa 2026.",price:0,name:"Pintinho no Ovo de P\xE1scoa",amount:1},{weight:0,economy:425,key:"fichacassino",slot:3,index:"fichacassino",premium:!1,desc:"Colecion\xE1vel.",price:0,name:"Ficha de Cassino N\xBA 7",amount:1},{weight:0,economy:425,key:"goldstar",slot:4,premium:!1,index:"goldstar",desc:"Estrela dourada do Ano Novo 2026.",price:0,name:"Estrela Dourada",amount:1},{weight:0,economy:425,key:"coolercarnaval",slot:5,premium:!1,index:"coolercarnaval",desc:"Carnaval 2026.",price:0,name:"Cooler da Folia",amount:1},{weight:0,economy:425,key:"baralho",slot:6,index:"baralho",premium:!1,price:0,name:"Cartas de Baralho",amount:1},{weight:0,economy:500,key:"leprechaun",slot:7,premium:!1,index:"leprechaun",desc:"VIP St. Patrick.",price:0,name:"Mascote Leprechaun",amount:1},{weight:0,economy:425,key:"coelhinhof",slot:8,premium:!1,index:"coelhinhof",desc:"P\xE1scoa 2026.",price:0,name:"Pet Coelhinho Feminino",amount:1},{weight:0,economy:425,key:"lobinho",slot:9,premium:!1,index:"lobinho",desc:"Sunset VIP.",price:0,name:"Lobinho",amount:1},{weight:0,economy:425,key:"tiaracarnaval",slot:10,premium:!1,index:"tiaracarnaval",desc:"Carnaval 2026.",price:0,name:"Tiara de Carnaval",amount:1},{weight:0,economy:425,key:"elf25",slot:11,premium:!1,index:"elf25",desc:"Natal 2025.",price:0,name:"Duende",amount:1},{weight:0,economy:425,key:"frevocarnaval",slot:12,premium:!1,index:"frevocarnaval",desc:"Carnaval 2026.",price:0,name:"Chap\xE9u de Frevo",amount:1},{weight:0,economy:425,key:"plumascarnaval",slot:13,premium:!1,index:"plumascarnaval",desc:"Carnaval 2026.",price:0,name:"Plumas de Carnaval",amount:1},{weight:0,economy:425,key:"peluciacenoura",slot:14,premium:!1,index:"peluciacenoura",desc:"P\xE1scoa 2026.",price:0,name:"Pel\xFAcia Cenoura",amount:1},{weight:0,economy:425,key:"cupidarrow",slot:15,premium:!1,index:"cupidarrow",desc:"Dia dos Namorados.",price:0,name:"Flecha de Cora\xE7\xE3o",amount:1},{weight:0,economy:425,key:"steeringwheel",slot:16,index:"steeringwheel",premium:!1,price:0,name:"Volante",amount:1},{weight:0,economy:400,key:"sun",slot:17,premium:!1,index:"sun",desc:"VIP P\xE9 Na Areia.",price:0,name:"Sol Radiante",amount:1},{weight:0,economy:425,key:"orelhapascoam",slot:18,premium:!1,index:"orelhapascoam",desc:"P\xE1scoa 2026.",price:0,name:"Orelhas P\xE1scoa Masculino",amount:1},{weight:0,economy:500,key:"tacadadados",slot:19,index:"tacadadados",premium:!1,price:0,name:"Ta\xE7a de Dados",amount:1},{weight:0,economy:500,key:"irishflag",slot:20,premium:!1,index:"irishflag",desc:"VIP St. Patrick.",price:0,name:"Bandeira Irlandesa",amount:1},{weight:0,economy:425,key:"placajuizo2",slot:21,premium:!1,index:"placajuizo2",desc:"Carnaval 2026.",price:0,name:"Plaquinha Procura-se Ju\xEDzo!",amount:1},{weight:0,economy:425,key:"placabeijo",slot:22,premium:!1,index:"placabeijo",desc:"Carnaval 2026.",price:0,name:"Plaquinha Beija ou Passa?",amount:1},{weight:0,economy:425,key:"placagolpe",slot:23,premium:!1,index:"placagolpe",desc:"Carnaval 2026.",price:0,name:"Plaquinha Golpe!",amount:1},{weight:0,economy:425,key:"cupidheart",slot:24,premium:!1,index:"cupidheart",desc:"Dia dos Namorados.",price:0,name:"Cora\xE7\xE3o do Cupido",amount:1},{weight:0,economy:425,key:"loveletter",slot:25,premium:!1,index:"loveletter",desc:"Dia dos Namorados.",price:0,name:"Carta de Amor",amount:1},{weight:0,economy:425,key:"calangocarnaval",slot:26,premium:!1,index:"calangocarnaval",desc:"Carnaval 2026.",price:0,name:"Mascote Calango",amount:1},{weight:0,economy:425,key:"macacocarnaval",slot:27,premium:!1,index:"macacocarnaval",desc:"Carnaval 2026.",price:0,name:"Macaco Foli\xE3o",amount:1},{weight:0,economy:425,key:"placajuizo",slot:28,premium:!1,index:"placajuizo",desc:"Carnaval 2026.",price:0,name:"Plaquinha Ju\xEDzo!",amount:1},{weight:0,economy:425,key:"tree25",slot:29,premium:!1,index:"tree25",desc:"Natal 2025.",price:0,name:"\xC1rvore de Natal",amount:1},{weight:0,economy:500,key:"potofgold",slot:30,premium:!1,index:"potofgold",desc:"VIP St. Patrick.",price:0,name:"Pote de Ouro",amount:1},{weight:0,economy:500,key:"clover",slot:31,premium:!1,index:"clover",desc:"VIP St. Patrick.",price:0,name:"Trevo de Quatro Folhas",amount:1},{weight:0,economy:425,key:"gatinhoabobora",slot:32,premium:!1,index:"gatinhoabobora",desc:"Halloween.",price:0,name:"Gatinho Ab\xF3bora",amount:1},{weight:0,economy:425,key:"santa25",slot:33,premium:!1,index:"santa25",desc:"Natal 2025.",price:0,name:"Papai Noel",amount:1},{weight:0,economy:425,key:"teddybear",slot:34,premium:!1,index:"teddybear",desc:"Ano Novo 2026.",price:0,name:"Ursinho de Pel\xFAcia",amount:1},{weight:0,economy:425,key:"placagolpe2",slot:35,premium:!1,index:"placagolpe2",desc:"Carnaval 2026.",price:0,name:"Plaquinha Cai no Golpe!",amount:1},{weight:0,economy:425,key:"moneygun",slot:36,index:"moneygun",premium:!1,price:0,name:"Gold Moneygun",amount:1},{weight:0,economy:425,key:"cottoncandy",slot:37,premium:!1,index:"cottoncandy",desc:"Dia dos Namorados.",price:0,name:"Algod\xE3o Doce de Cora\xE7\xE3o",amount:1},{weight:0,economy:425,key:"greenbeer",slot:38,premium:!1,index:"greenbeer",desc:"VIP St. Patrick.",price:0,name:"Cerveja Verde",amount:1},{weight:0,economy:425,key:"coelhinhom",slot:39,premium:!1,index:"coelhinhom",desc:"P\xE1scoa 2026.",price:0,name:"Pet Coelhinho Masculino",amount:1},{weight:0,economy:425,key:"pirulitopascoa",slot:40,premium:!1,index:"pirulitopascoa",desc:"P\xE1scoa 2026.",price:0,name:"Pirulito P\xE1scoa",amount:1},{weight:0,economy:425,key:"tiaracarnaval2",slot:41,premium:!1,index:"tiaracarnaval2",desc:"Carnaval 2026.",price:0,name:"Tiara de Carnavrau",amount:1},{weight:0,economy:425,key:"snow25",slot:42,premium:!1,index:"snow25",desc:"Natal 2025.",price:0,name:"Boneco de Neve",amount:1},{weight:0,economy:425,key:"flag",slot:43,index:"flag",premium:!1,price:0,name:"Bandeira",amount:1},{weight:0,economy:425,key:"partyhat",slot:44,premium:!1,index:"partyhat",desc:"Ano Novo 2026.",price:0,name:"Chap\xE9u de Festa",amount:1},{weight:0,economy:425,key:"trophybronze",slot:45,index:"trophybronze",premium:!1,price:0,name:"Trof\xE9u de Bronze",amount:1},{weight:0,economy:425,key:"dados",slot:46,index:"dados",premium:!1,price:0,name:"Dados de Cassino",amount:1},{weight:0,economy:425,key:"ovodouradopascoa",slot:47,premium:!1,index:"ovodouradopascoa",desc:"P\xE1scoa 2026.",price:0,name:"Ovo Gigante Dourado",amount:1},{weight:0,economy:425,key:"ren25",slot:48,premium:!1,index:"ren25",desc:"Natal 2025.",price:0,name:"Rena",amount:1},{weight:0,economy:425,key:"bananacat",slot:49,index:"bananacat",premium:!1,price:0,name:"Banana Cat",amount:1},{weight:0,economy:425,key:"surfboard",slot:50,premium:!1,index:"surfboard",desc:"VIP P\xE9 Na Areia.",price:0,name:"Prancha de Surf",amount:1},{weight:0,economy:425,key:"trophysilver",slot:51,index:"trophysilver",premium:!1,price:0,name:"Trof\xE9u de Prata",amount:1},{weight:0,economy:425,key:"trophygold",slot:52,index:"trophygold",premium:!1,price:0,name:"Trof\xE9u de Ouro",amount:1},{weight:0,economy:425,key:"sparkle",slot:53,premium:!1,index:"sparkle",desc:"Ano Novo 2026.",price:0,name:"Fa\xEDsca Festiva",amount:1},{weight:0,economy:500,key:"roleta",slot:54,index:"roleta",premium:!1,price:0,name:"Roleta de Cassino",amount:1},{weight:0,economy:425,key:"faquinha",slot:55,premium:!1,index:"faquinha",desc:"Sunset VIP.",price:0,name:"Faquinha",amount:1},{weight:0,economy:425,key:"fantasminha",slot:56,premium:!1,index:"fantasminha",desc:"Halloween.",price:0,name:"Fantasminha",amount:1},{weight:0,economy:425,key:"coroacarnaval",slot:57,premium:!1,index:"coroacarnaval",desc:"Carnaval 2026.",price:0,name:"Coroa de Plumas",amount:1},{weight:0,economy:425,key:"mochilacenoura",slot:58,premium:!1,index:"mochilacenoura",desc:"P\xE1scoa 2026.",price:0,name:"Mochila de Cenoura",amount:1},{weight:0,economy:425,key:"orelhapascoaf",slot:59,premium:!1,index:"orelhapascoaf",desc:"P\xE1scoa 2026.",price:0,name:"Orelhas P\xE1scoa Feminino",amount:1},{weight:0,economy:425,key:"bruxinha",slot:60,premium:!1,index:"bruxinha",desc:"Halloween.",price:0,name:"Bruxinha",amount:1},{weight:0,economy:425,key:"foice",slot:61,premium:!1,index:"foice",desc:"Halloween.",price:0,name:"Foice",amount:1},{weight:0,economy:425,key:"cupid",slot:62,premium:!1,index:"cupid",desc:"Dia dos Namorados.",price:0,name:"Anjo no Ombro",amount:1},{weight:0,economy:425,key:"crown",slot:63,index:"crown",premium:!1,price:0,name:"Coroa",amount:1},{weight:0,economy:425,key:"champagne",slot:64,index:"champagne",premium:!1,price:0,name:"Garrafa de Champanhe",amount:1},{weight:0,economy:425,key:"morceguinho",slot:65,premium:!1,index:"morceguinho",desc:"Halloween.",price:0,name:"Morceguinho",amount:1},{weight:0,economy:325,key:"crab",slot:66,premium:!1,index:"crab",desc:"VIP P\xE9 Na Areia.",price:0,name:"Caranguejo Travesso",amount:1},{weight:0,economy:425,key:"balaopascoaf",slot:67,premium:!1,index:"balaopascoaf",desc:"P\xE1scoa 2026.",price:0,name:"Bal\xE3o Coelhinho Feminino",amount:1},{weight:0,economy:500,key:"maletafichas",slot:68,index:"maletafichas",premium:!1,price:0,name:"Maleta de Fichas",amount:1},{key:"verify",slot:69,premium:!1,index:"verify",weight:0,price:0,name:"Deletado",amount:1},{weight:0,economy:425,key:"maletadinheiro",slot:70,index:"maletadinheiro",premium:!1,price:0,name:"Maleta de Dinheiro",amount:1},{weight:0,economy:425,key:"bouquet",slot:71,premium:!1,index:"bouquet",desc:"Dia dos Namorados.",price:0,name:"Buqu\xEA de Flores",amount:1},{weight:0,economy:300,key:"santa2",slot:72,premium:!1,index:"santa",desc:"VIP P\xE9 Na Areia.",price:0,name:"Letra A Angelical",amount:1},{weight:0,economy:425,key:"balloon",slot:73,premium:!1,index:"balloon",desc:"Ano Novo 2026.",price:0,name:"Bal\xE3o de Celebra\xE7\xE3o",amount:1},{weight:0,economy:425,key:"mochilacoelhof",slot:74,premium:!1,index:"mochilacoelhof",desc:"P\xE1scoa 2026.",price:0,name:"Mochila Coelho Feminino",amount:1},{weight:0,economy:425,key:"maozinhaaddams",slot:75,premium:!1,index:"maozinhaaddams",desc:"Sunset VIP.",price:0,name:"M\xE3ozinha Addams",amount:1},{weight:0,economy:425,key:"gift25",slot:76,premium:!1,index:"gift25",desc:"Natal 2025.",price:0,name:"Caixa de Presente",amount:1},{weight:0,economy:425,key:"nitro",slot:77,index:"nitro",premium:!1,price:0,name:"Nitro",amount:1},{weight:0,economy:425,key:"green25",slot:78,premium:!1,index:"green25",desc:"Natal 2025.",price:0,name:"Green",amount:1},{weight:0,economy:425,key:"balaopascoam",slot:79,premium:!1,index:"balaopascoam",desc:"P\xE1scoa 2026.",price:0,name:"Bal\xE3o Coelhinho Masculino",amount:1},{weight:0,economy:425,key:"faixapascoa",slot:80,premium:!1,index:"faixapascoa",desc:"P\xE1scoa 2026.",price:0,name:"Faixa de Evento P\xE1scoa",amount:1},{weight:0,economy:425,key:"mochilacoelhom",slot:81,premium:!1,index:"mochilacoelhom",desc:"P\xE1scoa 2026.",price:0,name:"Mochila Coelho Masculino",amount:1},{weight:0,economy:425,key:"dragao",slot:82,premium:!1,index:"dragao",desc:"Sunset VIP.",price:0,name:"Drag\xE3o",amount:1},{weight:0,economy:425,key:"ovodecoradopascoa",slot:83,premium:!1,index:"ovodecoradopascoa",desc:"P\xE1scoa 2026.",price:0,name:"Ovo Gigante Decorado",amount:1},{weight:0,economy:425,key:"cestapascoa",slot:84,premium:!1,index:"cestapascoa",desc:"P\xE1scoa 2026.",price:0,name:"Cesta de Ovos de P\xE1scoa",amount:1},{weight:0,economy:425,key:"romanticrose",slot:85,premium:!1,index:"romanticrose",desc:"Dia dos Namorados.",price:0,name:"Rosa Rom\xE2ntica",amount:1}],slots:85,type:e,weight:{current:10,max:100}});return t.slots=t.slots||50,t},fk=e=>{const[t,n]=v.exports.useState(!1),r=v.exports.useCallback(({key:i})=>{i===e&&n(!0)},[e]),o=v.exports.useCallback(({key:i})=>{i===e&&n(!1)},[e]);return v.exports.useEffect(()=>(window.addEventListener("keydown",r),window.addEventListener("keyup",o),()=>{window.removeEventListener("keydown",r),window.removeEventListener("keyup",o)}),[r,o]),t},Gm="inventory_collectibles_seen",hk=()=>{const[e,t]=v.exports.useState(0),[n,r]=v.exports.useState(!1),o=v.exports.useRef(!1),i=v.exports.useRef(null),s=v.exports.useRef(null),a=v.exports.useCallback((x,b)=>!x||!b?Gm:`${Gm}_${b}_${x}`,[]),l=v.exports.useCallback((x,b)=>{try{const g=a(x,b),h=localStorage.getItem(g);return h?JSON.parse(h):[]}catch{return[]}},[a]),c=v.exports.useCallback((x,b,g)=>{try{const h=a(b,g);localStorage.setItem(h,JSON.stringify(x))}catch{}},[a]),u=v.exports.useCallback(()=>{t(0),r(!1),o.current=!0},[]),d=v.exports.useCallback((x,b,g)=>{if(i.current&&b&&i.current!==b){t(0),r(!1);return}b&&(i.current=b),g&&(s.current=g);const h=l(b,g),m=x.filter(S=>!h.includes(S));m.length>0?(t(m.length),r(!0)):(t(0),r(!1))},[l]),p=v.exports.useCallback((x,b,g)=>{c(x,b,g),t(0),r(!1)},[c]),y=v.exports.useCallback(()=>({total:1}),[]),w=v.exports.useCallback((x,b,g)=>{if(x&&Array.isArray(x))if(o.current){const h=g||s.current;p(x,b,h),o.current=!1}else d(x,b,g)},[p,d]);return ot("updateCollectiblesCount",x=>{if(console.log("updateCollectiblesCount",JSON.stringify(x)),x&&x.ids){const b=x.accountId||null,g=x.cityName||null;w(x.ids,b,g)}}),v.exports.useEffect(()=>{const x=b=>{var S,E,T;const{type:g,action:h,data:m}=b.data||{};if(g==="updateCollectiblesCount"||h==="updateCollectiblesCount"){const I=(m==null?void 0:m.ids)||((S=b.data)==null?void 0:S.ids),O=(m==null?void 0:m.accountId)||((E=b.data)==null?void 0:E.accountId)||null,L=(m==null?void 0:m.cityName)||((T=b.data)==null?void 0:T.cityName)||null;I&&w(I,O,L)}};return window.addEventListener("message",x),()=>window.removeEventListener("message",x)},[w]),{notificationCount:e,hasNotification:n,clearNotification:u,markAsSeen:p,getCollectiblesCount:y,updateCollectiblesIds:d}},m5=v.exports.createContext(null),pk=({children:e})=>{const[t,n]=v.exports.useState(),[r,o]=v.exports.useState([]),[i,s]=v.exports.useState(),[a,l]=v.exports.useState(),[c,u]=v.exports.useState([]),[d,p]=v.exports.useState(1),[y,w]=v.exports.useState(),[x,b]=v.exports.useState(!1),[g,h]=v.exports.useState("all"),m=fk("Shift"),S=L=>{const _=L.filter(J=>J.slot<=5);u(_);const re=L.filter(J=>J.slot>=5);o(re)},E=async(L,_)=>{const re={...L,type:L.type==="hotbar"?"main":L.type},J={..._,type:_.type==="hotbar"?"main":_.type};if(!i||!a)return;const{newMainInventory:se,newSecondaryInventory:j}=await rk(re,J,i,a,d);s(se),S(se.items),l(j),p(1);try{window.dispatchEvent(new CustomEvent("inventory:drop",{detail:{from:L,to:_}}))}catch{}},T=async(L,_,re)=>{if(!i||!a)return;const{newMainInventory:J,newSecondaryInventory:se}=await ok(L,_,i,a,re!=null?re:d);s(J),S(J.items),l(se)};v.exports.useEffect(()=>{var L,_;b(m),y&&m&&p(m&&((L=y.item)==null?void 0:L.amount)?(_=y.item)==null?void 0:_.amount:d)},[m,y,d]);const I=()=>{vc("main").then(L=>{s(L),S(L.items)}),a&&vc(a.type).then(l)},O=L=>{vc(L).then(l)};return ot("updateInventory",I),f(m5.Provider,{value:{hoveringItem:t,setHoveringItem:n,mainInventory:i,inventoryItems:r,secondaryInventory:a,hotbarItems:c,updateMainInventory:I,updateSecondaryInventory:O,onDrop:E,onInteract:T,setCurrentAmount:p,currentAmount:d,setDraggingItem:w,pressingShift:x,draggingItem:y,filter:g,setFilter:h},children:e})},Et=()=>v.exports.useContext(m5),Vr=({type:e,secondType:t},n)=>e===n||t===n,Hf=C.div`
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: column;

  cursor: pointer;
  transition: all 0.2s;
  background: ${({isOver:e})=>e?"rgba(0, 0, 0, 0.3)":"rgba(0, 0, 0, 0.5)"};
  border-radius: 0.2rem;

  justify-content: space-between;

  position: relative;
  overflow: hidden;

  width: 100%;
  height: var(--slot-height);

  ${e=>Vr(e,"hotbar")&&de`
    height: var(--slot-width);
    overflow: visible;
  `}

  ${e=>Vr(e,"notify")&&de`
    width: 5.02rem;
  `}

  ${e=>Vr(e,"preview")&&de`
    transition: all 0s;
    opacity: 0;
    position: absolute;
    cursor: grab;
    width: var(--slot-width);
    overflow: hidden;
  `}

  ${e=>Vr(e,"notify")&&de`
    transform: scale(1.15);
  `}

  ${({isItem:e})=>!e&&de`
    cursor: default;
  `}

  ${e=>Vr(e,"shop")&&de`
    height: var(--slot-big-height) !important;
    width: var(--slot-big-width) !important;

    ${()=>Vr(e,"preview")&&de`
      transform: scale(0.9);
    `}
  `}

`,Ji=C.div`
  font-family: 'Poppins';
  font-style: normal;
  font-weight: 400;
  font-size: 0.725rem;
  line-height: 0.725rem;

  display: flex;
  align-items: center;
  justify-content: center;

  color: rgba(255, 255, 255, 0.5);
  z-index: 1;
`,mk=C.div`
  width: 100%;
  height: 100%;
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-direction: column;

  opacity: 0;
  animation: fadeIn 0.2s ease-in-out forwards;
  animation-delay: ${({index:e})=>e*.04}s;
  @keyframes fadeIn {
    0% {
      opacity: 0;
    }
    100% {
      opacity: 1;
    }
  }
`,gk=C.div`
  position: absolute;
  top: 50%;
  right: -20%;
  transform: translate(-50%, -50%);
  background: #ffffff;
  border-radius: 2px;
  width: 1.2rem;
  height: 1.2rem;
  display: flex;
  justify-content: center;
  align-items: center;

  font-weight: 700;
  font-size: 0.9rem;
  line-height: 0.9rem;

  span {
    margin-top: 0.2rem;
  }
`;var g5={color:void 0,size:void 0,className:void 0,style:void 0,attr:void 0},Km=Ke.createContext&&Ke.createContext(g5),Xn=globalThis&&globalThis.__assign||function(){return Xn=Object.assign||function(e){for(var t,n=1,r=arguments.length;n<r;n++){t=arguments[n];for(var o in t)Object.prototype.hasOwnProperty.call(t,o)&&(e[o]=t[o])}return e},Xn.apply(this,arguments)},yk=globalThis&&globalThis.__rest||function(e,t){var n={};for(var r in e)Object.prototype.hasOwnProperty.call(e,r)&&t.indexOf(r)<0&&(n[r]=e[r]);if(e!=null&&typeof Object.getOwnPropertySymbols=="function")for(var o=0,r=Object.getOwnPropertySymbols(e);o<r.length;o++)t.indexOf(r[o])<0&&Object.prototype.propertyIsEnumerable.call(e,r[o])&&(n[r[o]]=e[r[o]]);return n};function y5(e){return e&&e.map(function(t,n){return Ke.createElement(t.tag,Xn({key:n},t.attr),y5(t.child))})}function Ae(e){return function(t){return Ke.createElement(vk,Xn({attr:Xn({},e.attr)},t),y5(e.child))}}function vk(e){var t=function(n){var r=e.attr,o=e.size,i=e.title,s=yk(e,["attr","size","title"]),a=o||n.size||"1em",l;return n.className&&(l=n.className),e.className&&(l=(l?l+" ":"")+e.className),Ke.createElement("svg",Xn({stroke:"currentColor",fill:"currentColor",strokeWidth:"0"},n.attr,r,s,{className:l,style:Xn(Xn({color:e.color||n.color},n.style),e.style),height:a,width:a,xmlns:"http://www.w3.org/2000/svg"}),i&&Ke.createElement("title",null,i),e.children)};return Km!==void 0?Ke.createElement(Km.Consumer,null,function(n){return t(n)}):t(g5)}function xk(e){return Ae({tag:"svg",attr:{viewBox:"0 0 1024 1024"},child:[{tag:"path",attr:{d:"M834.1 469.2A347.49 347.49 0 0 0 751.2 354l-29.1-26.7a8.09 8.09 0 0 0-13 3.3l-13 37.3c-8.1 23.4-23 47.3-44.1 70.8-1.4 1.5-3 1.9-4.1 2-1.1.1-2.8-.1-4.3-1.5-1.4-1.2-2.1-3-2-4.8 3.7-60.2-14.3-128.1-53.7-202C555.3 171 510 123.1 453.4 89.7l-41.3-24.3c-5.4-3.2-12.3 1-12 7.3l2.2 48c1.5 32.8-2.3 61.8-11.3 85.9-11 29.5-26.8 56.9-47 81.5a295.64 295.64 0 0 1-47.5 46.1 352.6 352.6 0 0 0-100.3 121.5A347.75 347.75 0 0 0 160 610c0 47.2 9.3 92.9 27.7 136a349.4 349.4 0 0 0 75.5 110.9c32.4 32 70 57.2 111.9 74.7C418.5 949.8 464.5 959 512 959s93.5-9.2 136.9-27.3A348.6 348.6 0 0 0 760.8 857c32.4-32 57.8-69.4 75.5-110.9a344.2 344.2 0 0 0 27.7-136c0-48.8-10-96.2-29.9-140.9z"}}]})(e)}function wk(e){return Ae({tag:"svg",attr:{viewBox:"0 0 1024 1024"},child:[{tag:"path",attr:{d:"M512 64C264.6 64 64 264.6 64 512s200.6 448 448 448 448-200.6 448-448S759.4 64 512 64zm192 472c0 4.4-3.6 8-8 8H328c-4.4 0-8-3.6-8-8v-48c0-4.4 3.6-8 8-8h368c4.4 0 8 3.6 8 8v48z"}}]})(e)}function bk(e){return Ae({tag:"svg",attr:{viewBox:"0 0 1024 1024"},child:[{tag:"path",attr:{d:"M512 64C264.6 64 64 264.6 64 512s200.6 448 448 448 448-200.6 448-448S759.4 64 512 64zm192 472c0 4.4-3.6 8-8 8H544v152c0 4.4-3.6 8-8 8h-48c-4.4 0-8-3.6-8-8V544H328c-4.4 0-8-3.6-8-8v-48c0-4.4 3.6-8 8-8h152V328c0-4.4 3.6-8 8-8h48c4.4 0 8 3.6 8 8v152h152c4.4 0 8 3.6 8 8v48z"}}]})(e)}function Ck(e){return Ae({tag:"svg",attr:{viewBox:"0 0 1024 1024"},child:[{tag:"path",attr:{d:"M512 64C264.6 64 64 264.6 64 512s200.6 448 448 448 448-200.6 448-448S759.4 64 512 64zm234.8 736.5L223.5 277.2c16-19.7 34-37.7 53.7-53.7l523.3 523.3c-16 19.6-34 37.7-53.7 53.7z"}}]})(e)}const Sk=C(Ji)`
  background: rgba(0, 0, 0, 0.45);
  color: rgba(255, 255, 255, 0.8);
  font-weight: 500;
  height: 1.35rem;
  border-radius: .25vw .25vw 0 0;
  padding: 0 0.5em;
  display: flex;
  align-items: center;
  justify-content: center;

  font-size: .8rem;
  font-weight: 700;

  position: absolute;
  right: 0.25rem;
  bottom: 1.75rem;
  
  z-index: 3 !important;

  svg {
    height: .85rem;
    width: .85rem;
    margin-right: 0.2rem;
    text-shadow: 0 0 10px #f20a45;
    color: #f20a45;
    animation: fire 1s infinite;
  }
  
  @keyframes fire {
    0% {
      transform: scale(1);
    }
    50% {
      transform: scale(1.1);
    }
    100% {
      transform: scale(1);
    }
  }
`;function kk({stock:e}){return e===void 0?f(pe,{}):P(Sk,{children:[f("div",{children:f(xk,{})}),e]})}const Pk=C.div`
  filter: drop-shadow(0px 0px 7px #176ACB);
  display: flex;
  align-items: center;
  justify-content: center;
`;function Aa(){return f("svg",{xmlns:"http://www.w3.org/2000/svg",width:"7",height:"11",viewBox:"0 0 7 11",fill:"none",children:f("path",{d:"M6.588 7.056C6.588 7.496 6.472 7.904 6.24 8.28C6.016 8.648 5.68 8.952 5.232 9.192C4.792 9.424 4.268 9.552 3.66 9.576V10.548H2.892V9.564C2.044 9.492 1.36 9.24 0.84 8.808C0.32 8.368 0.044 7.772 0.012 7.02H2.196C2.244 7.5 2.476 7.808 2.892 7.944V6.048C2.268 5.888 1.768 5.732 1.392 5.58C1.024 5.428 0.7 5.184 0.42 4.848C0.14 4.512 0 4.052 0 3.468C0 2.74 0.268 2.156 0.804 1.716C1.348 1.276 2.044 1.028 2.892 0.972V0H3.66V0.972C4.5 1.036 5.164 1.28 5.652 1.704C6.14 2.128 6.412 2.716 6.468 3.468H4.272C4.224 3.036 4.02 2.756 3.66 2.628V4.488C4.324 4.672 4.836 4.836 5.196 4.98C5.556 5.124 5.876 5.364 6.156 5.7C6.444 6.028 6.588 6.48 6.588 7.056ZM2.172 3.372C2.172 3.572 2.232 3.74 2.352 3.876C2.48 4.012 2.66 4.132 2.892 4.236V2.568C2.668 2.608 2.492 2.696 2.364 2.832C2.236 2.96 2.172 3.14 2.172 3.372ZM3.66 7.98C3.9 7.94 4.088 7.844 4.224 7.692C4.368 7.54 4.44 7.352 4.44 7.128C4.44 6.92 4.372 6.752 4.236 6.624C4.108 6.488 3.916 6.372 3.66 6.276V7.98Z",fill:"#21FF6B"})})}function Tk(){return f(Pk,{children:f("svg",{width:"11",height:"9",viewBox:"0 0 11 9",fill:"none",xmlns:"http://www.w3.org/2000/svg",children:f("path",{d:"M10.9083 3.0028L8.34142 0.122848C8.3071 0.0843659 8.26482 0.0535055 8.21739 0.0323226C8.16997 0.0111398 8.1185 0.000120933 8.0664 0H2.93271C2.88061 0.000120933 2.82914 0.0111398 2.78171 0.0323226C2.73429 0.0535055 2.69201 0.0843659 2.65769 0.122848L0.0908471 3.0028C0.0309651 3.06992 -0.0013937 3.15648 4.6059e-05 3.2457C0.00148581 3.33491 0.0366215 3.42042 0.0986393 3.48565L5.23233 8.88556C5.26664 8.92167 5.30815 8.95047 5.35428 8.97015C5.40041 8.98984 5.45017 9 5.50047 9C5.55077 9 5.60053 8.98984 5.64666 8.97015C5.69279 8.95047 5.7343 8.92167 5.76861 8.88556L10.9023 3.48565C10.9641 3.4202 10.9989 3.33456 11 3.24535C11.0011 3.15614 10.9684 3.0697 10.9083 3.0028ZM9.82514 2.87996H7.88305L6.23294 0.719989H7.90001L9.82514 2.87996ZM3.05097 3.59994L4.43202 6.98974L1.20972 3.59994H3.05097ZM7.94814 3.59994H9.78939L6.56709 6.98974L7.94814 3.59994ZM3.0991 0.719989H4.76617L3.11606 2.87996H1.17396L3.0991 0.719989Z",fill:"#0075FF"})})})}function v5({isPremium:e}){return e?f(Tk,{}):f(Aa,{})}const Ek=C(Ji)`
  position: absolute;
  right: 0.5rem;
  top: 0.5rem;

  svg {
    height: 0.75rem;
    width: 0.75rem;
    margin-bottom: 0.05rem;
  }

  ${({isMoney:e,atRight:t})=>e&&`
    left: ${t?"unset":"0.5rem"};
    right: ${t?"0.5rem":"unset"};
    font-weight: 600;
  `}
`;function Ik({amount:e,isMoney:t,atRight:n}){return e!==void 0&&e>0?P(Ek,{isMoney:t,atRight:n,children:[t?f(Aa,{}):null,t?Bf(e,2):ck(e)]}):f(pe,{})}const Ok=C.div`
  width: 3px;
  height: calc(100% - var(--slot-name-height));
  position: absolute;
  bottom: var(--slot-name-height);
  left: 0;
  transform: rotate(180deg);
  z-index: 2;
  border-radius: 1px 53px 0.2rem 0.2rem;
  overflow: hidden;
  background: rgba(0, 0, 0, 0.4);

  ${({inventoryType:e})=>e==="shop"&&de`
    bottom: 1.6rem;
    height: calc(100% - 1.6rem);
  `}

  ${({inventoryType:e})=>e==="hotbar"&&de`
    bottom: 0;
    height: 100%;
    border-radius: 0 0 0.2rem 0.2rem;
  `}
`,Ak=C.div`
  height: ${e=>e.percent<=0?100:e.percent}%;
  width: 100%;
  background: ${e=>e.color};
  border-radius: 53px 1px 0.2rem 0.2rem;
  transition: height 0.3s ease-in-out, background 0.3s ease-in-out;
  box-shadow: ${e=>e.color!=="transparent"?`0 0 7px 0 ${e.color}`:"none"};
  position: relative;
`;function Dk({days:e,durability:t,...n}){if(t===void 0)return f(pe,{});if(e===void 0||e<0)return f(pe,{});const r=jf(e,t),o=p5(e,t);return f(Ok,{...n,children:f(Ak,{color:o,percent:r})})}function x5({index:e,fallbackKey:t,imageSrc:n,...r}){const[o,i]=v.exports.useState(0),s=v.exports.useRef(2);return f("img",{src:n!=null?n:nn(e),onError:({currentTarget:a})=>{i(l=>l+1),t&&t!==e&&o<s.current&&a.src!==nn(t)?(a.onerror=null,a.src=nn(t)):a.src!==nn("no-image")&&(a.onerror=null,a.src=nn("no-image"))},...r})}const Mk=C(x5)`
  width: 65%;
  height: 50%;
  object-fit: contain;
  object-position: center center;
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);

  z-index: 0;

  ${({$isBig:e})=>e&&de`
    width: 87.5%;
    height: 72.5%;
  `}
`;function Rk({index:e,isBig:t,fallbackKey:n,...r}){return e?f(Mk,{$isBig:t,index:e,fallbackKey:n,...r}):f(pe,{})}function $k(e){return Ae({tag:"svg",attr:{viewBox:"0 0 512 512"},child:[{tag:"path",attr:{d:"M256 48C141.31 48 48 141.32 48 256c0 114.86 93.14 208 208 208 114.69 0 208-93.31 208-208 0-114.87-93.13-208-208-208zm0 313a94 94 0 010-188h4.21l-14.11-14.1a14 14 0 0119.8-19.8l40 40a14 14 0 010 19.8l-40 40a14 14 0 01-19.8-19.8l18-18c-2.38-.1-5.1-.1-8.1-.1a66 66 0 1066 66 14 14 0 0128 0 94.11 94.11 0 01-94 94z"}}]})(e)}function Lk(e){return Ae({tag:"svg",attr:{viewBox:"0 0 512 512"},child:[{tag:"path",attr:{d:"M105 32v30h191.607l16.663-30zm3.805 48c4.309 10.899-5.352 29.724-9.276 38.588-11.006 24.703-28.728 57.602-42.02 95.43-13.29 37.828-22.212 80.865-15.15 126.119 7.063 45.254 30.318 92.356 79.56 137.496L124.5 480h263l2.58-2.367c49.243-45.14 72.498-92.242 79.56-137.496 7.063-45.254-1.859-88.291-15.15-126.12-13.29-37.827-31.013-70.726-42.02-95.43-4.475-10.046-7.742-18.751-9.312-25.372l-75.117 35.273 63.037 32.295-36.267 78.457 61.921 19.205-153.521 138.17 65.975-116.119-58.2-3.172 47.735-96.314-73.21-27.018L286.61 80H108.805z"}}]})(e)}const Nk=C(Ji)`
  color: white;
  font-weight: 500;
  height: 1rem;
  border-radius: 2px;
  padding: 0 0.25rem;
  text-transform: uppercase;

  position: absolute;
  top: 0.375rem;
  left: 0.25rem;
`,_k={added:{icon:f(bk,{}),color:"rgba(138, 234, 146, 0.8)"},removed:{icon:f(wk,{}),color:"rgba(221, 28, 26, 0.8)"},updated:{icon:f($k,{}),color:"rgba(87, 115, 122, 0.8)"},broke:{icon:f(Lk,{}),color:"rgba(80, 21, 55, 0.8)"}},Fk={icon:f(Ck,{}),color:"rgba(0, 0, 0, 0.8)"};function zk({mode:e}){if(!e)return f(pe,{});const t=_k[e]||Fk;return f(Nk,{style:{background:t.color},children:t.icon})}const Vk=C.div`
  background: rgba(0, 0, 0, 0.58);
  border-radius: 0px 0px 0.2rem 0.2rem;
  width: 100%;

  position: absolute;
  bottom: 0;

  font-weight: 400;
  font-size: 52.5%;
  text-align: center;
  text-transform: uppercase;

  display: flex;
  justify-content: center;
  align-items: center;
  
  height: var(--slot-name-height);

  color: rgba(255, 255, 255, 0.5);


  span {
    width: 85%;
    white-space: nowrap;
    // text with ... at the end
    overflow: hidden;
    text-overflow: ellipsis;
  }
  


  ${({inventoryType:e})=>e==="shop"&&de`
    font-size: 0.85rem;
    height: 1.725rem;
  `}
`;function jk({children:e,inventoryType:t}){return e?f(Vk,{inventoryType:t,children:f("span",{children:e})}):f(pe,{})}const Bk=C.div`
  display: flex;
  flex-direction: column;

  position: absolute;
  right: 5vw;
  top: 5vw;

  button {
    padding: 1rem;
    border: 0;
    border-bottom: 1px solid rgba(255, 255, 255, 0.2);
    background: rgba(0, 0, 0, 0.5);
    color: #fff;
    font-size: 1rem;
    font-weight: bold;
    text-transform: uppercase;
    cursor: pointer;
    transition: 0.2s;

    border-radius: 0.25vw;

    &:hover {
      background: rgba(0, 0, 0, 0.8);
    }
  }
`;function Uk(){if(!pt())return f(pe,{});Zt();const e=cl(),{setHoveringItem:t}=Et();return P(Bk,{children:[["chest","hotbar","shop","main","ground","preview","trunk","property","inspect"].map(r=>f("button",{onClick:()=>{e(`/${r}`)},children:r},r)),f("button",{onClick:()=>{t({key:"meth",days:20,desc:"The Methamphetamine is a drug that can be made from a meth lab. It is used to make joints and blunts.",economy:0,index:"meth",name:"Meth",amount:6,max:1,weight:.1,hotbarIndex:0,price:100,slot:8,durability:1e4})},children:"Fake Hover"}),f("button",{onClick:()=>{window.postMessage({action:"tutorialInventory:start",data:{steps:[{target:'[data-tutorial-target="shop-slot-1"]',placement:"left",title:"Arraste para comprar",content:"Para comprar um item da loja, segure o clique esquerdo e arraste para seu invent\xE1rio.",advanceOnDrop:!0,advanceOnDropFrom:{fromType:"shop",fromSlot:1},advanceOnDropTo:{toType:"main"}}]}},"*")},children:"Start Tutorial"}),f("button",{onClick:()=>{window.postMessage({action:"tutorialInventory:close"},"*")},children:"Close Tutorial"})]})}const w5=v.exports.createContext({dragDropManager:void 0});function Dt(e){return"Minified Redux error #"+e+"; visit https://redux.js.org/Errors?code="+e+" for the full message or use the non-minified dev environment for full errors. "}var Ym=function(){return typeof Symbol=="function"&&Symbol.observable||"@@observable"}(),xc=function(){return Math.random().toString(36).substring(7).split("").join(".")},Qm={INIT:"@@redux/INIT"+xc(),REPLACE:"@@redux/REPLACE"+xc(),PROBE_UNKNOWN_ACTION:function(){return"@@redux/PROBE_UNKNOWN_ACTION"+xc()}};function Hk(e){if(typeof e!="object"||e===null)return!1;for(var t=e;Object.getPrototypeOf(t)!==null;)t=Object.getPrototypeOf(t);return Object.getPrototypeOf(e)===t}function b5(e,t,n){var r;if(typeof t=="function"&&typeof n=="function"||typeof n=="function"&&typeof arguments[3]=="function")throw new Error(Dt(0));if(typeof t=="function"&&typeof n=="undefined"&&(n=t,t=void 0),typeof n!="undefined"){if(typeof n!="function")throw new Error(Dt(1));return n(b5)(e,t)}if(typeof e!="function")throw new Error(Dt(2));var o=e,i=t,s=[],a=s,l=!1;function c(){a===s&&(a=s.slice())}function u(){if(l)throw new Error(Dt(3));return i}function d(x){if(typeof x!="function")throw new Error(Dt(4));if(l)throw new Error(Dt(5));var b=!0;return c(),a.push(x),function(){if(!!b){if(l)throw new Error(Dt(6));b=!1,c();var h=a.indexOf(x);a.splice(h,1),s=null}}}function p(x){if(!Hk(x))throw new Error(Dt(7));if(typeof x.type=="undefined")throw new Error(Dt(8));if(l)throw new Error(Dt(9));try{l=!0,i=o(i,x)}finally{l=!1}for(var b=s=a,g=0;g<b.length;g++){var h=b[g];h()}return x}function y(x){if(typeof x!="function")throw new Error(Dt(10));o=x,p({type:Qm.REPLACE})}function w(){var x,b=d;return x={subscribe:function(h){if(typeof h!="object"||h===null)throw new Error(Dt(11));function m(){h.next&&h.next(u())}m();var S=b(m);return{unsubscribe:S}}},x[Ym]=function(){return this},x}return p({type:Qm.INIT}),r={dispatch:p,subscribe:d,getState:u,replaceReducer:y},r[Ym]=w,r}function ce(e,t,...n){if(Wk()&&t===void 0)throw new Error("invariant requires an error message argument");if(!e){let r;if(t===void 0)r=new Error("Minified exception occurred; use the non-minified dev environment for the full error message and additional helpful warnings.");else{let o=0;r=new Error(t.replace(/%s/g,function(){return n[o++]})),r.name="Invariant Violation"}throw r.framesToPop=1,r}}function Wk(){return typeof process!="undefined"&&process.env.NODE_ENV==="production"}function Gk(e,t,n){return t.split(".").reduce((r,o)=>r&&r[o]?r[o]:n||null,e)}function Kk(e,t){return e.filter(n=>n!==t)}function C5(e){return typeof e=="object"}function Yk(e,t){const n=new Map,r=i=>{n.set(i,n.has(i)?n.get(i)+1:1)};e.forEach(r),t.forEach(r);const o=[];return n.forEach((i,s)=>{i===1&&o.push(s)}),o}function Qk(e,t){return e.filter(n=>t.indexOf(n)>-1)}const Wf="dnd-core/INIT_COORDS",Cl="dnd-core/BEGIN_DRAG",Gf="dnd-core/PUBLISH_DRAG_SOURCE",Sl="dnd-core/HOVER",kl="dnd-core/DROP",Pl="dnd-core/END_DRAG";function Xm(e,t){return{type:Wf,payload:{sourceClientOffset:t||null,clientOffset:e||null}}}const Xk={type:Wf,payload:{clientOffset:null,sourceClientOffset:null}};function qk(e){return function(n=[],r={publishSource:!0}){const{publishSource:o=!0,clientOffset:i,getSourceClientOffset:s}=r,a=e.getMonitor(),l=e.getRegistry();e.dispatch(Xm(i)),Zk(n,a,l);const c=t8(n,a);if(c==null){e.dispatch(Xk);return}let u=null;if(i){if(!s)throw new Error("getSourceClientOffset must be defined");Jk(s),u=s(c)}e.dispatch(Xm(i,u));const p=l.getSource(c).beginDrag(a,c);if(p==null)return;e8(p),l.pinSource(c);const y=l.getSourceType(c);return{type:Cl,payload:{itemType:y,item:p,sourceId:c,clientOffset:i||null,sourceClientOffset:u||null,isSourcePublic:!!o}}}}function Zk(e,t,n){ce(!t.isDragging(),"Cannot call beginDrag while dragging."),e.forEach(function(r){ce(n.getSource(r),"Expected sourceIds to be registered.")})}function Jk(e){ce(typeof e=="function","When clientOffset is provided, getSourceClientOffset must be a function.")}function e8(e){ce(C5(e),"Item must be an object.")}function t8(e,t){let n=null;for(let r=e.length-1;r>=0;r--)if(t.canDragSource(e[r])){n=e[r];break}return n}function n8(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function r8(e){for(var t=1;t<arguments.length;t++){var n=arguments[t]!=null?arguments[t]:{},r=Object.keys(n);typeof Object.getOwnPropertySymbols=="function"&&(r=r.concat(Object.getOwnPropertySymbols(n).filter(function(o){return Object.getOwnPropertyDescriptor(n,o).enumerable}))),r.forEach(function(o){n8(e,o,n[o])})}return e}function o8(e){return function(n={}){const r=e.getMonitor(),o=e.getRegistry();i8(r),l8(r).forEach((s,a)=>{const l=s8(s,a,o,r),c={type:kl,payload:{dropResult:r8({},n,l)}};e.dispatch(c)})}}function i8(e){ce(e.isDragging(),"Cannot call drop while not dragging."),ce(!e.didDrop(),"Cannot call drop twice during one drag operation.")}function s8(e,t,n,r){const o=n.getTarget(e);let i=o?o.drop(r,e):void 0;return a8(i),typeof i=="undefined"&&(i=t===0?{}:r.getDropResult()),i}function a8(e){ce(typeof e=="undefined"||C5(e),"Drop result must either be an object or undefined.")}function l8(e){const t=e.getTargetIds().filter(e.canDropOnTarget,e);return t.reverse(),t}function c8(e){return function(){const n=e.getMonitor(),r=e.getRegistry();u8(n);const o=n.getSourceId();return o!=null&&(r.getSource(o,!0).endDrag(n,o),r.unpinSource()),{type:Pl}}}function u8(e){ce(e.isDragging(),"Cannot call endDrag while not dragging.")}function Ju(e,t){return t===null?e===null:Array.isArray(e)?e.some(n=>n===t):e===t}function d8(e){return function(n,{clientOffset:r}={}){f8(n);const o=n.slice(0),i=e.getMonitor(),s=e.getRegistry(),a=i.getItemType();return p8(o,s,a),h8(o,i,s),m8(o,i,s),{type:Sl,payload:{targetIds:o,clientOffset:r||null}}}}function f8(e){ce(Array.isArray(e),"Expected targetIds to be an array.")}function h8(e,t,n){ce(t.isDragging(),"Cannot call hover while not dragging."),ce(!t.didDrop(),"Cannot call hover after drop.");for(let r=0;r<e.length;r++){const o=e[r];ce(e.lastIndexOf(o)===r,"Expected targetIds to be unique in the passed array.");const i=n.getTarget(o);ce(i,"Expected targetIds to be registered.")}}function p8(e,t,n){for(let r=e.length-1;r>=0;r--){const o=e[r],i=t.getTargetType(o);Ju(i,n)||e.splice(r,1)}}function m8(e,t,n){e.forEach(function(r){n.getTarget(r).hover(t,r)})}function g8(e){return function(){if(e.getMonitor().isDragging())return{type:Gf}}}function y8(e){return{beginDrag:qk(e),publishDragSource:g8(e),hover:d8(e),drop:o8(e),endDrag:c8(e)}}class v8{receiveBackend(t){this.backend=t}getMonitor(){return this.monitor}getBackend(){return this.backend}getRegistry(){return this.monitor.registry}getActions(){const t=this,{dispatch:n}=this.store;function r(i){return(...s)=>{const a=i.apply(t,s);typeof a!="undefined"&&n(a)}}const o=y8(this);return Object.keys(o).reduce((i,s)=>{const a=o[s];return i[s]=r(a),i},{})}dispatch(t){this.store.dispatch(t)}constructor(t,n){this.isSetUp=!1,this.handleRefCountChange=()=>{const r=this.store.getState().refCount>0;this.backend&&(r&&!this.isSetUp?(this.backend.setup(),this.isSetUp=!0):!r&&this.isSetUp&&(this.backend.teardown(),this.isSetUp=!1))},this.store=t,this.monitor=n,t.subscribe(this.handleRefCountChange)}}function x8(e,t){return{x:e.x+t.x,y:e.y+t.y}}function S5(e,t){return{x:e.x-t.x,y:e.y-t.y}}function w8(e){const{clientOffset:t,initialClientOffset:n,initialSourceClientOffset:r}=e;return!t||!n||!r?null:S5(x8(t,r),n)}function b8(e){const{clientOffset:t,initialClientOffset:n}=e;return!t||!n?null:S5(t,n)}const yi=[],Kf=[];yi.__IS_NONE__=!0;Kf.__IS_ALL__=!0;function C8(e,t){return e===yi?!1:e===Kf||typeof t=="undefined"?!0:Qk(t,e).length>0}class S8{subscribeToStateChange(t,n={}){const{handlerIds:r}=n;ce(typeof t=="function","listener must be a function."),ce(typeof r=="undefined"||Array.isArray(r),"handlerIds, when specified, must be an array of strings.");let o=this.store.getState().stateId;const i=()=>{const s=this.store.getState(),a=s.stateId;try{a===o||a===o+1&&!C8(s.dirtyHandlerIds,r)||t()}finally{o=a}};return this.store.subscribe(i)}subscribeToOffsetChange(t){ce(typeof t=="function","listener must be a function.");let n=this.store.getState().dragOffset;const r=()=>{const o=this.store.getState().dragOffset;o!==n&&(n=o,t())};return this.store.subscribe(r)}canDragSource(t){if(!t)return!1;const n=this.registry.getSource(t);return ce(n,`Expected to find a valid source. sourceId=${t}`),this.isDragging()?!1:n.canDrag(this,t)}canDropOnTarget(t){if(!t)return!1;const n=this.registry.getTarget(t);if(ce(n,`Expected to find a valid target. targetId=${t}`),!this.isDragging()||this.didDrop())return!1;const r=this.registry.getTargetType(t),o=this.getItemType();return Ju(r,o)&&n.canDrop(this,t)}isDragging(){return Boolean(this.getItemType())}isDraggingSource(t){if(!t)return!1;const n=this.registry.getSource(t,!0);if(ce(n,`Expected to find a valid source. sourceId=${t}`),!this.isDragging()||!this.isSourcePublic())return!1;const r=this.registry.getSourceType(t),o=this.getItemType();return r!==o?!1:n.isDragging(this,t)}isOverTarget(t,n={shallow:!1}){if(!t)return!1;const{shallow:r}=n;if(!this.isDragging())return!1;const o=this.registry.getTargetType(t),i=this.getItemType();if(i&&!Ju(o,i))return!1;const s=this.getTargetIds();if(!s.length)return!1;const a=s.indexOf(t);return r?a===s.length-1:a>-1}getItemType(){return this.store.getState().dragOperation.itemType}getItem(){return this.store.getState().dragOperation.item}getSourceId(){return this.store.getState().dragOperation.sourceId}getTargetIds(){return this.store.getState().dragOperation.targetIds}getDropResult(){return this.store.getState().dragOperation.dropResult}didDrop(){return this.store.getState().dragOperation.didDrop}isSourcePublic(){return Boolean(this.store.getState().dragOperation.isSourcePublic)}getInitialClientOffset(){return this.store.getState().dragOffset.initialClientOffset}getInitialSourceClientOffset(){return this.store.getState().dragOffset.initialSourceClientOffset}getClientOffset(){return this.store.getState().dragOffset.clientOffset}getSourceClientOffset(){return w8(this.store.getState().dragOffset)}getDifferenceFromInitialOffset(){return b8(this.store.getState().dragOffset)}constructor(t,n){this.store=t,this.registry=n}}const qm=typeof global!="undefined"?global:self,k5=qm.MutationObserver||qm.WebKitMutationObserver;function P5(e){return function(){const n=setTimeout(o,0),r=setInterval(o,50);function o(){clearTimeout(n),clearInterval(r),e()}}}function k8(e){let t=1;const n=new k5(e),r=document.createTextNode("");return n.observe(r,{characterData:!0}),function(){t=-t,r.data=t}}const P8=typeof k5=="function"?k8:P5;class T8{enqueueTask(t){const{queue:n,requestFlush:r}=this;n.length||(r(),this.flushing=!0),n[n.length]=t}constructor(){this.queue=[],this.pendingErrors=[],this.flushing=!1,this.index=0,this.capacity=1024,this.flush=()=>{const{queue:t}=this;for(;this.index<t.length;){const n=this.index;if(this.index++,t[n].call(),this.index>this.capacity){for(let r=0,o=t.length-this.index;r<o;r++)t[r]=t[r+this.index];t.length-=this.index,this.index=0}}t.length=0,this.index=0,this.flushing=!1},this.registerPendingError=t=>{this.pendingErrors.push(t),this.requestErrorThrow()},this.requestFlush=P8(this.flush),this.requestErrorThrow=P5(()=>{if(this.pendingErrors.length)throw this.pendingErrors.shift()})}}class E8{call(){try{this.task&&this.task()}catch(t){this.onError(t)}finally{this.task=null,this.release(this)}}constructor(t,n){this.onError=t,this.release=n,this.task=null}}class I8{create(t){const n=this.freeTasks,r=n.length?n.pop():new E8(this.onError,o=>n[n.length]=o);return r.task=t,r}constructor(t){this.onError=t,this.freeTasks=[]}}const T5=new T8,O8=new I8(T5.registerPendingError);function A8(e){T5.enqueueTask(O8.create(e))}const Yf="dnd-core/ADD_SOURCE",Qf="dnd-core/ADD_TARGET",Xf="dnd-core/REMOVE_SOURCE",Tl="dnd-core/REMOVE_TARGET";function D8(e){return{type:Yf,payload:{sourceId:e}}}function M8(e){return{type:Qf,payload:{targetId:e}}}function R8(e){return{type:Xf,payload:{sourceId:e}}}function $8(e){return{type:Tl,payload:{targetId:e}}}function L8(e){ce(typeof e.canDrag=="function","Expected canDrag to be a function."),ce(typeof e.beginDrag=="function","Expected beginDrag to be a function."),ce(typeof e.endDrag=="function","Expected endDrag to be a function.")}function N8(e){ce(typeof e.canDrop=="function","Expected canDrop to be a function."),ce(typeof e.hover=="function","Expected hover to be a function."),ce(typeof e.drop=="function","Expected beginDrag to be a function.")}function ed(e,t){if(t&&Array.isArray(e)){e.forEach(n=>ed(n,!1));return}ce(typeof e=="string"||typeof e=="symbol",t?"Type can only be a string, a symbol, or an array of either.":"Type can only be a string or a symbol.")}var _t;(function(e){e.SOURCE="SOURCE",e.TARGET="TARGET"})(_t||(_t={}));let _8=0;function F8(){return _8++}function z8(e){const t=F8().toString();switch(e){case _t.SOURCE:return`S${t}`;case _t.TARGET:return`T${t}`;default:throw new Error(`Unknown Handler Role: ${e}`)}}function Zm(e){switch(e[0]){case"S":return _t.SOURCE;case"T":return _t.TARGET;default:throw new Error(`Cannot parse handler ID: ${e}`)}}function Jm(e,t){const n=e.entries();let r=!1;do{const{done:o,value:[,i]}=n.next();if(i===t)return!0;r=!!o}while(!r);return!1}class V8{addSource(t,n){ed(t),L8(n);const r=this.addHandler(_t.SOURCE,t,n);return this.store.dispatch(D8(r)),r}addTarget(t,n){ed(t,!0),N8(n);const r=this.addHandler(_t.TARGET,t,n);return this.store.dispatch(M8(r)),r}containsHandler(t){return Jm(this.dragSources,t)||Jm(this.dropTargets,t)}getSource(t,n=!1){return ce(this.isSourceId(t),"Expected a valid source ID."),n&&t===this.pinnedSourceId?this.pinnedSource:this.dragSources.get(t)}getTarget(t){return ce(this.isTargetId(t),"Expected a valid target ID."),this.dropTargets.get(t)}getSourceType(t){return ce(this.isSourceId(t),"Expected a valid source ID."),this.types.get(t)}getTargetType(t){return ce(this.isTargetId(t),"Expected a valid target ID."),this.types.get(t)}isSourceId(t){return Zm(t)===_t.SOURCE}isTargetId(t){return Zm(t)===_t.TARGET}removeSource(t){ce(this.getSource(t),"Expected an existing source."),this.store.dispatch(R8(t)),A8(()=>{this.dragSources.delete(t),this.types.delete(t)})}removeTarget(t){ce(this.getTarget(t),"Expected an existing target."),this.store.dispatch($8(t)),this.dropTargets.delete(t),this.types.delete(t)}pinSource(t){const n=this.getSource(t);ce(n,"Expected an existing source."),this.pinnedSourceId=t,this.pinnedSource=n}unpinSource(){ce(this.pinnedSource,"No source is pinned at the time."),this.pinnedSourceId=null,this.pinnedSource=null}addHandler(t,n,r){const o=z8(t);return this.types.set(o,n),t===_t.SOURCE?this.dragSources.set(o,r):t===_t.TARGET&&this.dropTargets.set(o,r),o}constructor(t){this.types=new Map,this.dragSources=new Map,this.dropTargets=new Map,this.pinnedSourceId=null,this.pinnedSource=null,this.store=t}}const j8=(e,t)=>e===t;function B8(e,t){return!e&&!t?!0:!e||!t?!1:e.x===t.x&&e.y===t.y}function U8(e,t,n=j8){if(e.length!==t.length)return!1;for(let r=0;r<e.length;++r)if(!n(e[r],t[r]))return!1;return!0}function H8(e=yi,t){switch(t.type){case Sl:break;case Yf:case Qf:case Tl:case Xf:return yi;case Cl:case Gf:case Pl:case kl:default:return Kf}const{targetIds:n=[],prevTargetIds:r=[]}=t.payload,o=Yk(n,r);if(!(o.length>0||!U8(n,r)))return yi;const s=r[r.length-1],a=n[n.length-1];return s!==a&&(s&&o.push(s),a&&o.push(a)),o}function W8(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function G8(e){for(var t=1;t<arguments.length;t++){var n=arguments[t]!=null?arguments[t]:{},r=Object.keys(n);typeof Object.getOwnPropertySymbols=="function"&&(r=r.concat(Object.getOwnPropertySymbols(n).filter(function(o){return Object.getOwnPropertyDescriptor(n,o).enumerable}))),r.forEach(function(o){W8(e,o,n[o])})}return e}const e0={initialSourceClientOffset:null,initialClientOffset:null,clientOffset:null};function K8(e=e0,t){const{payload:n}=t;switch(t.type){case Wf:case Cl:return{initialSourceClientOffset:n.sourceClientOffset,initialClientOffset:n.clientOffset,clientOffset:n.clientOffset};case Sl:return B8(e.clientOffset,n.clientOffset)?e:G8({},e,{clientOffset:n.clientOffset});case Pl:case kl:return e0;default:return e}}function Y8(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function jr(e){for(var t=1;t<arguments.length;t++){var n=arguments[t]!=null?arguments[t]:{},r=Object.keys(n);typeof Object.getOwnPropertySymbols=="function"&&(r=r.concat(Object.getOwnPropertySymbols(n).filter(function(o){return Object.getOwnPropertyDescriptor(n,o).enumerable}))),r.forEach(function(o){Y8(e,o,n[o])})}return e}const Q8={itemType:null,item:null,sourceId:null,targetIds:[],dropResult:null,didDrop:!1,isSourcePublic:null};function X8(e=Q8,t){const{payload:n}=t;switch(t.type){case Cl:return jr({},e,{itemType:n.itemType,item:n.item,sourceId:n.sourceId,isSourcePublic:n.isSourcePublic,dropResult:null,didDrop:!1});case Gf:return jr({},e,{isSourcePublic:!0});case Sl:return jr({},e,{targetIds:n.targetIds});case Tl:return e.targetIds.indexOf(n.targetId)===-1?e:jr({},e,{targetIds:Kk(e.targetIds,n.targetId)});case kl:return jr({},e,{dropResult:n.dropResult,didDrop:!0,targetIds:[]});case Pl:return jr({},e,{itemType:null,item:null,sourceId:null,dropResult:null,didDrop:!1,isSourcePublic:null,targetIds:[]});default:return e}}function q8(e=0,t){switch(t.type){case Yf:case Qf:return e+1;case Xf:case Tl:return e-1;default:return e}}function Z8(e=0){return e+1}function J8(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function e7(e){for(var t=1;t<arguments.length;t++){var n=arguments[t]!=null?arguments[t]:{},r=Object.keys(n);typeof Object.getOwnPropertySymbols=="function"&&(r=r.concat(Object.getOwnPropertySymbols(n).filter(function(o){return Object.getOwnPropertyDescriptor(n,o).enumerable}))),r.forEach(function(o){J8(e,o,n[o])})}return e}function t7(e={},t){return{dirtyHandlerIds:H8(e.dirtyHandlerIds,{type:t.type,payload:e7({},t.payload,{prevTargetIds:Gk(e,"dragOperation.targetIds",[])})}),dragOffset:K8(e.dragOffset,t),refCount:q8(e.refCount,t),dragOperation:X8(e.dragOperation,t),stateId:Z8(e.stateId)}}function n7(e,t=void 0,n={},r=!1){const o=r7(r),i=new S8(o,new V8(o)),s=new v8(o,i),a=e(s,t,n);return s.receiveBackend(a),s}function r7(e){const t=typeof window!="undefined"&&window.__REDUX_DEVTOOLS_EXTENSION__;return b5(t7,e&&t&&t({name:"dnd-core",instanceId:"dnd-core"}))}function o7(e,t){if(e==null)return{};var n=i7(e,t),r,o;if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);for(o=0;o<i.length;o++)r=i[o],!(t.indexOf(r)>=0)&&(!Object.prototype.propertyIsEnumerable.call(e,r)||(n[r]=e[r]))}return n}function i7(e,t){if(e==null)return{};var n={},r=Object.keys(e),o,i;for(i=0;i<r.length;i++)o=r[i],!(t.indexOf(o)>=0)&&(n[o]=e[o]);return n}let t0=0;const Hs=Symbol.for("__REACT_DND_CONTEXT_INSTANCE__");var s7=v.exports.memo(function(t){var{children:n}=t,r=o7(t,["children"]);const[o,i]=a7(r);return v.exports.useEffect(()=>{if(i){const s=E5();return++t0,()=>{--t0===0&&(s[Hs]=null)}}},[]),f(w5.Provider,{value:o,children:n})});function a7(e){if("manager"in e)return[{dragDropManager:e.manager},!1];const t=l7(e.backend,e.context,e.options,e.debugMode),n=!e.context;return[t,n]}function l7(e,t=E5(),n,r){const o=t;return o[Hs]||(o[Hs]={dragDropManager:n7(e,t,n,r)}),o[Hs]}function E5(){return typeof global!="undefined"?global:window}var c7=function e(t,n){if(t===n)return!0;if(t&&n&&typeof t=="object"&&typeof n=="object"){if(t.constructor!==n.constructor)return!1;var r,o,i;if(Array.isArray(t)){if(r=t.length,r!=n.length)return!1;for(o=r;o--!==0;)if(!e(t[o],n[o]))return!1;return!0}if(t.constructor===RegExp)return t.source===n.source&&t.flags===n.flags;if(t.valueOf!==Object.prototype.valueOf)return t.valueOf()===n.valueOf();if(t.toString!==Object.prototype.toString)return t.toString()===n.toString();if(i=Object.keys(t),r=i.length,r!==Object.keys(n).length)return!1;for(o=r;o--!==0;)if(!Object.prototype.hasOwnProperty.call(n,i[o]))return!1;for(o=r;o--!==0;){var s=i[o];if(!e(t[s],n[s]))return!1}return!0}return t!==t&&n!==n};const Dr=typeof window!="undefined"?v.exports.useLayoutEffect:v.exports.useEffect;function u7(e,t,n){const[r,o]=v.exports.useState(()=>t(e)),i=v.exports.useCallback(()=>{const s=t(e);c7(r,s)||(o(s),n&&n())},[r,e,n]);return Dr(i),[r,i]}function d7(e,t,n){const[r,o]=u7(e,t,n);return Dr(function(){const s=e.getHandlerId();if(s!=null)return e.subscribeToStateChange(o,{handlerIds:[s]})},[e,o]),r}function I5(e,t,n){return d7(t,e||(()=>({})),()=>n.reconnect())}function O5(e,t){const n=[...t||[]];return t==null&&typeof e!="function"&&n.push(e),v.exports.useMemo(()=>typeof e=="function"?e():e,n)}function f7(e){return v.exports.useMemo(()=>e.hooks.dragSource(),[e])}function h7(e){return v.exports.useMemo(()=>e.hooks.dragPreview(),[e])}let wc=!1,bc=!1;class p7{receiveHandlerId(t){this.sourceId=t}getHandlerId(){return this.sourceId}canDrag(){ce(!wc,"You may not call monitor.canDrag() inside your canDrag() implementation. Read more: http://react-dnd.github.io/react-dnd/docs/api/drag-source-monitor");try{return wc=!0,this.internalMonitor.canDragSource(this.sourceId)}finally{wc=!1}}isDragging(){if(!this.sourceId)return!1;ce(!bc,"You may not call monitor.isDragging() inside your isDragging() implementation. Read more: http://react-dnd.github.io/react-dnd/docs/api/drag-source-monitor");try{return bc=!0,this.internalMonitor.isDraggingSource(this.sourceId)}finally{bc=!1}}subscribeToStateChange(t,n){return this.internalMonitor.subscribeToStateChange(t,n)}isDraggingSource(t){return this.internalMonitor.isDraggingSource(t)}isOverTarget(t,n){return this.internalMonitor.isOverTarget(t,n)}getTargetIds(){return this.internalMonitor.getTargetIds()}isSourcePublic(){return this.internalMonitor.isSourcePublic()}getSourceId(){return this.internalMonitor.getSourceId()}subscribeToOffsetChange(t){return this.internalMonitor.subscribeToOffsetChange(t)}canDragSource(t){return this.internalMonitor.canDragSource(t)}canDropOnTarget(t){return this.internalMonitor.canDropOnTarget(t)}getItemType(){return this.internalMonitor.getItemType()}getItem(){return this.internalMonitor.getItem()}getDropResult(){return this.internalMonitor.getDropResult()}didDrop(){return this.internalMonitor.didDrop()}getInitialClientOffset(){return this.internalMonitor.getInitialClientOffset()}getInitialSourceClientOffset(){return this.internalMonitor.getInitialSourceClientOffset()}getSourceClientOffset(){return this.internalMonitor.getSourceClientOffset()}getClientOffset(){return this.internalMonitor.getClientOffset()}getDifferenceFromInitialOffset(){return this.internalMonitor.getDifferenceFromInitialOffset()}constructor(t){this.sourceId=null,this.internalMonitor=t.getMonitor()}}let Cc=!1;class m7{receiveHandlerId(t){this.targetId=t}getHandlerId(){return this.targetId}subscribeToStateChange(t,n){return this.internalMonitor.subscribeToStateChange(t,n)}canDrop(){if(!this.targetId)return!1;ce(!Cc,"You may not call monitor.canDrop() inside your canDrop() implementation. Read more: http://react-dnd.github.io/react-dnd/docs/api/drop-target-monitor");try{return Cc=!0,this.internalMonitor.canDropOnTarget(this.targetId)}finally{Cc=!1}}isOver(t){return this.targetId?this.internalMonitor.isOverTarget(this.targetId,t):!1}getItemType(){return this.internalMonitor.getItemType()}getItem(){return this.internalMonitor.getItem()}getDropResult(){return this.internalMonitor.getDropResult()}didDrop(){return this.internalMonitor.didDrop()}getInitialClientOffset(){return this.internalMonitor.getInitialClientOffset()}getInitialSourceClientOffset(){return this.internalMonitor.getInitialSourceClientOffset()}getSourceClientOffset(){return this.internalMonitor.getSourceClientOffset()}getClientOffset(){return this.internalMonitor.getClientOffset()}getDifferenceFromInitialOffset(){return this.internalMonitor.getDifferenceFromInitialOffset()}constructor(t){this.targetId=null,this.internalMonitor=t.getMonitor()}}function g7(e,t,n){const r=n.getRegistry(),o=r.addTarget(e,t);return[o,()=>r.removeTarget(o)]}function y7(e,t,n){const r=n.getRegistry(),o=r.addSource(e,t);return[o,()=>r.removeSource(o)]}function td(e,t,n,r){let o=n?n.call(r,e,t):void 0;if(o!==void 0)return!!o;if(e===t)return!0;if(typeof e!="object"||!e||typeof t!="object"||!t)return!1;const i=Object.keys(e),s=Object.keys(t);if(i.length!==s.length)return!1;const a=Object.prototype.hasOwnProperty.bind(t);for(let l=0;l<i.length;l++){const c=i[l];if(!a(c))return!1;const u=e[c],d=t[c];if(o=n?n.call(r,u,d,c):void 0,o===!1||o===void 0&&u!==d)return!1}return!0}function nd(e){return e!==null&&typeof e=="object"&&Object.prototype.hasOwnProperty.call(e,"current")}function v7(e){if(typeof e.type=="string")return;const t=e.type.displayName||e.type.name||"the component";throw new Error(`Only native element nodes can now be passed to React DnD connectors.You can either wrap ${t} into a <div>, or turn it into a drag source or a drop target itself.`)}function x7(e){return(t=null,n=null)=>{if(!v.exports.isValidElement(t)){const i=t;return e(i,n),i}const r=t;return v7(r),w7(r,n?i=>e(i,n):e)}}function A5(e){const t={};return Object.keys(e).forEach(n=>{const r=e[n];if(n.endsWith("Ref"))t[n]=e[n];else{const o=x7(r);t[n]=()=>o}}),t}function n0(e,t){typeof e=="function"?e(t):e.current=t}function w7(e,t){const n=e.ref;return ce(typeof n!="string","Cannot connect React DnD to an element with an existing string ref. Please convert it to use a callback ref instead, or wrap it into a <span> or <div>. Read more: https://reactjs.org/docs/refs-and-the-dom.html#callback-refs"),n?v.exports.cloneElement(e,{ref:r=>{n0(n,r),n0(t,r)}}):v.exports.cloneElement(e,{ref:t})}class b7{receiveHandlerId(t){this.handlerId!==t&&(this.handlerId=t,this.reconnect())}get connectTarget(){return this.dragSource}get dragSourceOptions(){return this.dragSourceOptionsInternal}set dragSourceOptions(t){this.dragSourceOptionsInternal=t}get dragPreviewOptions(){return this.dragPreviewOptionsInternal}set dragPreviewOptions(t){this.dragPreviewOptionsInternal=t}reconnect(){const t=this.reconnectDragSource();this.reconnectDragPreview(t)}reconnectDragSource(){const t=this.dragSource,n=this.didHandlerIdChange()||this.didConnectedDragSourceChange()||this.didDragSourceOptionsChange();return n&&this.disconnectDragSource(),this.handlerId?t?(n&&(this.lastConnectedHandlerId=this.handlerId,this.lastConnectedDragSource=t,this.lastConnectedDragSourceOptions=this.dragSourceOptions,this.dragSourceUnsubscribe=this.backend.connectDragSource(this.handlerId,t,this.dragSourceOptions)),n):(this.lastConnectedDragSource=t,n):n}reconnectDragPreview(t=!1){const n=this.dragPreview,r=t||this.didHandlerIdChange()||this.didConnectedDragPreviewChange()||this.didDragPreviewOptionsChange();if(r&&this.disconnectDragPreview(),!!this.handlerId){if(!n){this.lastConnectedDragPreview=n;return}r&&(this.lastConnectedHandlerId=this.handlerId,this.lastConnectedDragPreview=n,this.lastConnectedDragPreviewOptions=this.dragPreviewOptions,this.dragPreviewUnsubscribe=this.backend.connectDragPreview(this.handlerId,n,this.dragPreviewOptions))}}didHandlerIdChange(){return this.lastConnectedHandlerId!==this.handlerId}didConnectedDragSourceChange(){return this.lastConnectedDragSource!==this.dragSource}didConnectedDragPreviewChange(){return this.lastConnectedDragPreview!==this.dragPreview}didDragSourceOptionsChange(){return!td(this.lastConnectedDragSourceOptions,this.dragSourceOptions)}didDragPreviewOptionsChange(){return!td(this.lastConnectedDragPreviewOptions,this.dragPreviewOptions)}disconnectDragSource(){this.dragSourceUnsubscribe&&(this.dragSourceUnsubscribe(),this.dragSourceUnsubscribe=void 0)}disconnectDragPreview(){this.dragPreviewUnsubscribe&&(this.dragPreviewUnsubscribe(),this.dragPreviewUnsubscribe=void 0,this.dragPreviewNode=null,this.dragPreviewRef=null)}get dragSource(){return this.dragSourceNode||this.dragSourceRef&&this.dragSourceRef.current}get dragPreview(){return this.dragPreviewNode||this.dragPreviewRef&&this.dragPreviewRef.current}clearDragSource(){this.dragSourceNode=null,this.dragSourceRef=null}clearDragPreview(){this.dragPreviewNode=null,this.dragPreviewRef=null}constructor(t){this.hooks=A5({dragSource:(n,r)=>{this.clearDragSource(),this.dragSourceOptions=r||null,nd(n)?this.dragSourceRef=n:this.dragSourceNode=n,this.reconnectDragSource()},dragPreview:(n,r)=>{this.clearDragPreview(),this.dragPreviewOptions=r||null,nd(n)?this.dragPreviewRef=n:this.dragPreviewNode=n,this.reconnectDragPreview()}}),this.handlerId=null,this.dragSourceRef=null,this.dragSourceOptionsInternal=null,this.dragPreviewRef=null,this.dragPreviewOptionsInternal=null,this.lastConnectedHandlerId=null,this.lastConnectedDragSource=null,this.lastConnectedDragSourceOptions=null,this.lastConnectedDragPreview=null,this.lastConnectedDragPreviewOptions=null,this.backend=t}}class C7{get connectTarget(){return this.dropTarget}reconnect(){const t=this.didHandlerIdChange()||this.didDropTargetChange()||this.didOptionsChange();t&&this.disconnectDropTarget();const n=this.dropTarget;if(!!this.handlerId){if(!n){this.lastConnectedDropTarget=n;return}t&&(this.lastConnectedHandlerId=this.handlerId,this.lastConnectedDropTarget=n,this.lastConnectedDropTargetOptions=this.dropTargetOptions,this.unsubscribeDropTarget=this.backend.connectDropTarget(this.handlerId,n,this.dropTargetOptions))}}receiveHandlerId(t){t!==this.handlerId&&(this.handlerId=t,this.reconnect())}get dropTargetOptions(){return this.dropTargetOptionsInternal}set dropTargetOptions(t){this.dropTargetOptionsInternal=t}didHandlerIdChange(){return this.lastConnectedHandlerId!==this.handlerId}didDropTargetChange(){return this.lastConnectedDropTarget!==this.dropTarget}didOptionsChange(){return!td(this.lastConnectedDropTargetOptions,this.dropTargetOptions)}disconnectDropTarget(){this.unsubscribeDropTarget&&(this.unsubscribeDropTarget(),this.unsubscribeDropTarget=void 0)}get dropTarget(){return this.dropTargetNode||this.dropTargetRef&&this.dropTargetRef.current}clearDropTarget(){this.dropTargetRef=null,this.dropTargetNode=null}constructor(t){this.hooks=A5({dropTarget:(n,r)=>{this.clearDropTarget(),this.dropTargetOptions=r,nd(n)?this.dropTargetRef=n:this.dropTargetNode=n,this.reconnect()}}),this.handlerId=null,this.dropTargetRef=null,this.dropTargetOptionsInternal=null,this.lastConnectedHandlerId=null,this.lastConnectedDropTarget=null,this.lastConnectedDropTargetOptions=null,this.backend=t}}function Nr(){const{dragDropManager:e}=v.exports.useContext(w5);return ce(e!=null,"Expected drag drop context"),e}function S7(e,t){const n=Nr(),r=v.exports.useMemo(()=>new b7(n.getBackend()),[n]);return Dr(()=>(r.dragSourceOptions=e||null,r.reconnect(),()=>r.disconnectDragSource()),[r,e]),Dr(()=>(r.dragPreviewOptions=t||null,r.reconnect(),()=>r.disconnectDragPreview()),[r,t]),r}function k7(){const e=Nr();return v.exports.useMemo(()=>new p7(e),[e])}class P7{beginDrag(){const t=this.spec,n=this.monitor;let r=null;return typeof t.item=="object"?r=t.item:typeof t.item=="function"?r=t.item(n):r={},r!=null?r:null}canDrag(){const t=this.spec,n=this.monitor;return typeof t.canDrag=="boolean"?t.canDrag:typeof t.canDrag=="function"?t.canDrag(n):!0}isDragging(t,n){const r=this.spec,o=this.monitor,{isDragging:i}=r;return i?i(o):n===t.getSourceId()}endDrag(){const t=this.spec,n=this.monitor,r=this.connector,{end:o}=t;o&&o(n.getItem(),n),r.reconnect()}constructor(t,n,r){this.spec=t,this.monitor=n,this.connector=r}}function T7(e,t,n){const r=v.exports.useMemo(()=>new P7(e,t,n),[t,n]);return v.exports.useEffect(()=>{r.spec=e},[e]),r}function E7(e){return v.exports.useMemo(()=>{const t=e.type;return ce(t!=null,"spec.type must be defined"),t},[e])}function I7(e,t,n){const r=Nr(),o=T7(e,t,n),i=E7(e);Dr(function(){if(i!=null){const[a,l]=y7(i,o,r);return t.receiveHandlerId(a),n.receiveHandlerId(a),l}},[r,t,n,o,i])}function D5(e,t){const n=O5(e,t);ce(!n.begin,"useDrag::spec.begin was deprecated in v14. Replace spec.begin() with spec.item(). (see more here - https://react-dnd.github.io/react-dnd/docs/api/use-drag)");const r=k7(),o=S7(n.options,n.previewOptions);return I7(n,r,o),[I5(n.collect,r,o),f7(o),h7(o)]}function O7(e){return v.exports.useMemo(()=>e.hooks.dropTarget(),[e])}function A7(e){const t=Nr(),n=v.exports.useMemo(()=>new C7(t.getBackend()),[t]);return Dr(()=>(n.dropTargetOptions=e||null,n.reconnect(),()=>n.disconnectDropTarget()),[e]),n}function D7(){const e=Nr();return v.exports.useMemo(()=>new m7(e),[e])}function M7(e){const{accept:t}=e;return v.exports.useMemo(()=>(ce(e.accept!=null,"accept must be defined"),Array.isArray(t)?t:[t]),[t])}class R7{canDrop(){const t=this.spec,n=this.monitor;return t.canDrop?t.canDrop(n.getItem(),n):!0}hover(){const t=this.spec,n=this.monitor;t.hover&&t.hover(n.getItem(),n)}drop(){const t=this.spec,n=this.monitor;if(t.drop)return t.drop(n.getItem(),n)}constructor(t,n){this.spec=t,this.monitor=n}}function $7(e,t){const n=v.exports.useMemo(()=>new R7(e,t),[t]);return v.exports.useEffect(()=>{n.spec=e},[e]),n}function L7(e,t,n){const r=Nr(),o=$7(e,t),i=M7(e);Dr(function(){const[a,l]=g7(i,o,r);return t.receiveHandlerId(a),n.receiveHandlerId(a),l},[r,t,o,n,i.map(s=>s.toString()).join("|")])}function uo(e,t){const n=O5(e,t),r=D7(),o=A7(n.options);return L7(n,r,o),[I5(n.collect,r,o),O7(o)]}function M5({item:e,type:t,isMain:n}){var T;const{setHoveringItem:r,pressingShift:o,setDraggingItem:i,onDrop:s,onInteract:a,mainInventory:l,secondaryInventory:c,currentAmount:u}=Et(),d=v.exports.useRef(null),p=()=>{!Nt(e)||r(e)},y=()=>{!Nt(e)||r(void 0)},[{isDragging:w},x]=D5(()=>({type:"drag",collect:I=>({isDragging:I.isDragging()}),item:()=>({item:Nt(e)?e:void 0,type:t}),canDrag:()=>Nt(e),end:()=>{i(void 0)}}),[e,l,c,u]),[{isOver:b},g]=uo(()=>({accept:"drag",collect:I=>({isOver:I.isOver()}),drop:I=>{s(I,{slot:e.slot,type:t})}}),[e,l,c,u]);v.exports.useEffect(()=>{w&&i({type:t,item:e})},[w]);const h=n?`main-slot-${e.slot}`:`${t}-slot-${e.slot}`,m=I=>x(g(I)),S=((T=e.amount)!=null?T:0)-(w?u:0);return f(Hf,{ref:I=>{d&&typeof d=="object"&&(d.current=I),I&&m(I)},onMouseEnter:p,onMouseLeave:y,type:t,isItem:Nt(e),isOver:b,"data-tutorial-target":h,onMouseDown:I=>{if(I.button!==2||!Nt(e)||t!=="main"&&t!=="hotbar"&&t!=="shop")return;I.preventDefault();const O=o?e.amount:1;a({type:t,item:{...e,amount:O}},"use",O)},children:P(mk,{index:e.slot,children:[f(Zf,{item:{...e,amount:S},inventoryType:t}),t==="hotbar"&&f(gk,{children:f("span",{children:e.slot})})]})})}const N7=C.div`
  width: 100%;
  height: 3px;
  position: relative;
`,_7=C.div`
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, ${({theme:e,percentage:t})=>`${e.colors.main[500]} ${t!=null?t:0}%`}, rgba(0, 0, 0, 0) 100%);
  border-radius: 0.1vw;

  position: absolute;
  top: 0;
  left: 0;
`;function R5({percentage:e}){return f(N7,{children:f(_7,{percentage:e*2-100})})}const F7=C.div`
  display: flex;
  align-items: center;
  width: 100%;
  height: 100%;
  background: rgba(0,0,0,0.58);
  border-radius: 4px;
  width: 100%;
  height: 100%;
  padding-right: 1.7rem;
  grid-area: 3 / 2 / 4 / 3;

  h1 {
    font-size: .83rem;
    font-weight: 600;
    color: #FFFFFF;
  }

  span {
    color: rgba(255, 255, 255, 0.5);
  }
`,z7=C.div`
  display: grid;
  grid-template-columns: 1fr 1fr;
  grid-gap: 1rem;
  grid-column-gap: 10rem;
  padding: 0rem 1.7rem;
`,V7=C.div`
  display: grid;
  align-items: center;
  grid-template-columns: 1.6fr 1fr;
  grid-gap: 2rem;
  width: 100%;
  height: 100%;
`,j7=C.div`
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  gap: .5rem;
  height: 100%;
  overflow: hidden;
  border-radius: .2rem;

  p {
    height: 100%;
    width: 19.5vw;
  
    font-weight: 400;
    font-size: 0.95rem;
    display: flex;
    align-items: center;

    color: #949494;

    background: rgba(0, 0, 0, 0.3);
    border-radius: 0px 0px .2rem .2rem;

    padding: 0.5rem 1rem;
  }
`,B7=C.div`
  display: flex;
  gap: .5rem;
  align-items: center;
  padding: 1rem 0rem 0rem 1.5rem;
  h1 {
    font-size: 1.05rem;
    font-weight: 600;
    color: #FFFFFF;
  }

  img {
    width: 1.5rem;
    height: 1.5rem;
    object-fit: contain;
  }
`,U7=C.div`
  display: flex;
  flex-direction: column;
  gap: .5vh;

  h1 {
    font-size: 0.95rem;
    line-height: 0.95rem;
    font-weight: 400;
    letter-spacing: 0em;
    color: rgba(255, 255, 255, 0.5);

    display: flex;
    align-items: center;
    justify-content: space-between;

    span {
      font-weight: 400;
      letter-spacing: 0em;
      text-align: right;
      color: #F0F0F0;
      white-space: nowrap;
      display: flex;
      align-items: center;
      height: 1rem;

      svg {
        margin-bottom: .15rem;
        height: 1rem;
        width: 1rem;
        margin-right: 0.25rem;
        display: flex;
        align-items: center;
        justify-content: center;
      }

      &.high {
        font-weight: 600;
      }
    }
  }
`;function H7(){const{getT:e}=Zt();try{if(!e||typeof e!="function")return f(pe,{});const t=e("utils");if(!t||!Array.isArray(t))return f(pe,{});const n=t;return n.length===0?f(pe,{}):f(z7,{children:n.map((r,o)=>P("h1",{children:["[",r.button,"] ",f("span",{children:r.description})]},o))})}catch{return f(pe,{})}}function W7(e){var r;const{t}=Zt(),n=e.index==="dollars";return P(V7,{children:[P(j7,{children:[P(B7,{children:[f(x5,{index:e.index},e.key),f("h1",{children:h5(e.index,e.name)})]}),f("p",{children:e.desc||t("noDescription")})]}),P(U7,{children:[e.price!==void 0?P("h1",{children:[t("priceDesc"),":"," ",P("span",{className:"high",children:[f(v5,{isPremium:e.premium}),Uf(e.price)]})]}):null,e.amount!==void 0?P("h1",{children:[t("quantityDesc"),":"," ",P("span",{className:n?"high":"",children:[n&&f(Aa,{}),dk(e)]})]}):null,e.stock!==void 0?P("h1",{children:[t("stockDesc"),": ",f("span",{children:e.stock})]}):null,e.weight!==void 0?P("h1",{children:[t("weightDesc"),":"," ",P("span",{children:[(e.weight*((r=e.amount)!=null?r:0)).toFixed(1),"kg"]})]}):null,e.economy!==void 0&&e.economy>0&&!n?P("h1",{children:[t("economyDesc"),":"," ",P("span",{className:"high",children:[f(Aa,{}),Bf(e.economy*e.amount)]})]}):null,e.durability!==void 0||e.Durability!==void 0?P("h1",{children:[t("expiresInDesc"),":"," ",f("span",{children:ik(e)})]}):null,e.days!==void 0&&(e.durability!==void 0||e.Durability!==void 0)?P("h1",{children:[t("durabilityDesc"),":"," ",f("span",{children:sk(e.days,t)})]}):null,e.charges!==void 0&&e.maxCharges!==void 0?P("h1",{children:[t("rechargeDesc"),":"," ",P("span",{style:{color:lk(e.charges,e.maxCharges)},children:[e.charges,"/",e.maxCharges]})]}):null,e.custom!==void 0?P(pe,{children:[e.custom.name?P("h1",{children:[t("nameDesc"),": ",f("span",{children:e.custom.name})]}):null,e.custom.passport?P("h1",{children:[t("passportDesc"),": ",f("span",{children:e.custom.passport})]}):null,e.custom.age?P("h1",{children:[t("ageDesc"),": ",f("span",{children:e.custom.age})]}):null,e.custom.hasRolepass?P("h1",{children:[t("rolepassDesc"),": ",f("span",{children:e.custom.hasRolepass})]}):null,e.custom.key?P("h1",{children:[t("keyDesc"),": ",f("span",{children:e.custom.key})]}):null,e.custom.phone?P("h1",{children:[t("phoneDesc"),": ",f("span",{children:e.custom.phone})]}):null,e.custom.premium?P("h1",{children:[t("premiumDesc"),": ",f("span",{children:e.custom.premium})]}):null,e.custom.suitcase?P("h1",{children:[t("suitcaseDesc"),": ",f("span",{children:e.custom.suitcase})]}):null]}):null]})]})}function G7(){const{hoveringItem:e}=Et(),[t,n]=v.exports.useState(),r=v.exports.useRef();return v.exports.useEffect(()=>(r.current&&(clearTimeout(r.current),r.current=void 0),e?r.current=setTimeout(()=>{n(e)},t?200:100):r.current=setTimeout(()=>{n(void 0)},1e3),()=>{r.current&&(clearTimeout(r.current),r.current=void 0)}),[e,t]),v.exports.useEffect(()=>()=>{r.current&&clearTimeout(r.current)},[]),f(F7,{children:f(bl.div,{initial:{opacity:.35},animate:{opacity:1},transition:{duration:1},style:{height:"100%",width:"100%",display:"flex",alignItems:"center"},children:t?f(W7,{...t}):f(H7,{})},t==null?void 0:t.name)})}const K7=C.div`
  display: flex;
  align-items: center;
  flex-direction: column;

  gap: var(--slot-gap);
  width: 100%;

  margin-top: var(--inventory-header-height);

  padding: 0rem 0.5vw;

  & > * {
    opacity: 0;

    &:nth-child(1) { animation-delay: 0.1s; }
    &:nth-child(2) { animation-delay: 0.2s; }
    &:nth-child(3) { animation-delay: 0.3s; }
    &:nth-child(4) { animation-delay: 0.4s; }
    &:nth-child(5) { animation-delay: 0.5s; }
    &:nth-child(6) { animation-delay: 0.6s; }
    &:nth-child(7) { animation-delay: 0.7s; }
    &:nth-child(8) { animation-delay: 0.8s; }
    animation: fadeIn 0.3s forwards;

    @keyframes fadeIn {
      0% { opacity: 0; }
      100% { opacity: 1; }
    }
  }
`,Wo=C.div`
  width: 100%;
  height: 2.8rem;
  font-size: 1rem;

  background: rgba(0, 0, 0, 0.5);
  border-radius: 0.4rem;
  color: #ffffff;
  cursor: pointer;

  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s;
  text-transform: uppercase;
  text-align: center;
  font-size: 0.8rem;
  font-weight: 500;

  &:hover {
    background: rgba(0, 0, 0, 0.8);
  }
  z-index: 1;

  ${({isOver:e})=>e&&`
    background: rgba(0, 0, 0, 0.8);
    color: rgba(255, 255, 255, 0.5);
  `}
`,Y7=C.input`
  width: 100%;
  height: 2.8rem;
  font-size: 1rem;

  border: none;
  outline: none;
  background: rgba(0, 0, 0, 0.5);
  border-radius: 0.4rem;
  color: #ffffff;

  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s;
  text-transform: uppercase;
  text-align: center;
  font-size: 0.9rem;
  font-weight: 500;

  &:hover {
    background: rgba(0, 0, 0, 0.8);
  }
`;function Q7(){const{secondaryInventory:e,onInteract:t,currentAmount:n,setCurrentAmount:r,mainInventory:o}=Et(),{t:i}=Zt(),{notificationCount:s,hasNotification:a,clearNotification:l}=iO(),[{isOverUse:c},u]=uo(()=>({accept:"drag",collect:T=>({isOverUse:T.isOver()}),drop:T=>{T.type!=="main"&&T.type!=="hotbar"||t(T,"use")}}),[e,o,n]),[{isOverSend:d},p]=uo(()=>({accept:"drag",collect:T=>({isOverSend:T.isOver(),canDrop:T.canDrop()}),drop:T=>{t(T,"send")}}),[e,o,n]),[{isOverDelivery:y},w]=uo(()=>({accept:"drag",collect:T=>({isOverDelivery:T.isOver(),canDrop:T.canDrop()}),drop:T=>{t(T,"delivery")}}),[e,o,n]),[{isOverDestruct:x},b]=uo(()=>({accept:"drag",collect:T=>({isOverDestruct:T.isOver()}),drop:T=>{t(T,"destruct")}}),[e,o,n]),g=T=>u(T),h=T=>p(T),m=T=>w(T),S=T=>b(T);return P(K7,{children:[f(Y7,{value:n,onChange:T=>{const I=T.target.value,O=parseInt(I)||0;O>=0&&r(O)}}),e&&e.type==="ground"&&P(pe,{children:[f(Wo,{ref:g,isOver:c,children:i("use")}),f(Wo,{ref:h,isOver:d,children:i("send")}),f(Wo,{ref:m,isOver:y,children:i("delivery")}),P(Wo,{onClick:()=>{Oe("openCollectibles"),l()},style:{position:"relative"},children:[i("collection"),f(aI,{count:s,isVisible:a})]}),f(Wo,{ref:S,isOver:x,children:i("destruct")})]})]})}const $5=C.div`
  display: flex;
  flex-direction: column;
  gap: 10px;
  width: max-content;
`,L5=C.div`
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 1.4rem;
`,N5=C.div`
  font-family: 'Poppins', sans-serif;
  font-weight: 600;
  font-size: 1.2rem;
  color: #FFFFFF;
  text-transform: uppercase;
`,_5=C.div`
  display: grid;
  grid-template-columns: repeat(4,var(--slot-width));
  gap: var(--slot-gap);
  width: max-content;
  flex-shrink: 0;
  height: 35rem;
  overflow-y: scroll;

  transition: all 0.2s ease-in-out;
  ${({type:e})=>e==="shop"&&de`
    grid-template-columns: repeat(3, var(--slot-big-width));
    gap: var(--slot-big-gap);
  `}

  &::-webkit-scrollbar {
    display: none;
  }
`,X7=C.div`
  font-family: 'Poppins', sans-serif;
  font-weight: 600;
  font-size: 1.2rem;
  color: #FFFFFF;

  span {
    color: #FFFFFF80;
  }
`,q7=C.div`
  position: relative;
  display: flex;
  align-items: flex-start;
  width: max-content;
`;C.div`
  display: flex;
  align-items: flex-start;
`;const Z7=C.div`
  display: flex;
  flex-direction: column;
  gap: var(--slot-gap);
  z-index: 100;
  margin-left: 1rem;
`,J7=C.button`
  display: flex;
  width: 32px;
  height: 32px;
  padding: 0.4rem;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  
  background: rgba(0, 0, 0, 0.5);
  border: none;
  border-radius: 0.4rem;
  color: #ffffff;
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
  cursor: pointer;

  &:hover {
    background: rgba(0, 0, 0, 0.8);
    transform: scale(1.05);
  }

  ${({active:e,theme:t})=>e&&de`
    background: ${t.colors.main[500]};
    color: #ffffff;
  `}

  svg {
    width: 100%;
    height: 100%;
    transition: transform 0.3s ease;
  }

  &:active svg {
    transform: scale(0.9);
  }
`,eP=[{id:"all",icon:f("svg",{xmlns:"http://www.w3.org/2000/svg",width:"20",height:"20",viewBox:"0 0 20 20",fill:"none",children:f("path",{d:"M3 3H17V6.23077H3V3ZM3 8.38462H17V11.6154H3V8.38462ZM3 13.7692H17V17H3V13.7692Z",fill:"currentColor"})}),label:"mostrar todos"},{id:"weapon",icon:f("svg",{xmlns:"http://www.w3.org/2000/svg",width:"20",height:"20",viewBox:"0 0 20 20",fill:"none",children:f("path",{d:"M17.4084 4.67496C17.3584 4.38329 17.1 4.16663 16.7917 4.16663C16.4834 4.16663 16.2334 4.38329 16.1834 4.66663H11.7917C11.625 4.66663 11.4667 4.73329 11.35 4.84996L11.0334 5.16663H9.05002L8.73335 4.84996C8.61669 4.73329 8.45835 4.66663 8.29169 4.66663H4.40002C4.34169 4.38329 4.09169 4.16663 3.79169 4.16663C3.49169 4.16663 3.23335 4.38329 3.18335 4.66663H2.29169C1.95002 4.66663 1.66669 4.94996 1.66669 5.29163V9.28329C1.66669 9.62496 1.95002 9.90829 2.29169 9.90829C2.58335 9.90829 2.85835 10.0666 3.00835 10.3166C3.15835 10.5666 3.16669 10.8833 2.99169 11.2L2.70835 11.725C2.03335 12.9666 1.67502 14.3666 1.67502 15.775C1.67502 16.1166 1.95835 16.4 2.30002 16.4H6.30002C6.58335 16.4 6.83335 16.2083 6.90835 15.925L7.66669 12.9H8.55002C10.0084 12.9 11.2167 11.8083 11.4 10.4H17.3C17.6417 10.4 17.925 10.1166 17.925 9.77496V5.29163C17.925 4.98329 17.7084 4.73329 17.4167 4.67496H17.4084ZM8.54169 11.6583H7.96669L8.20835 10.6916C8.25002 10.525 8.40002 10.4083 8.57502 10.4083H10.125C9.95835 11.125 9.30835 11.6583 8.54169 11.6583Z",fill:"currentColor"})}),label:"armas"},{id:"tool",icon:f("svg",{xmlns:"http://www.w3.org/2000/svg",width:"20",height:"20",viewBox:"0 0 20 20",fill:"none",children:f("path",{d:"M13.3949 2C12.666 1.99972 11.9475 2.17254 11.2985 2.50424C10.6495 2.83595 10.0886 3.31705 9.66185 3.90795C9.23513 4.49885 8.95482 5.18265 8.84402 5.90307C8.73322 6.62349 8.79508 7.35993 9.02452 8.05176L2.42595 14.6524C2.15321 14.9253 2 15.2954 2 15.6813C2 16.0671 2.15321 16.4372 2.42595 16.7101L3.28902 17.5733C3.42411 17.7086 3.58455 17.8159 3.76115 17.8891C3.93775 17.9623 4.12705 18 4.31823 18C4.5094 18 4.6987 17.9623 4.8753 17.8891C5.0519 17.8159 5.21234 17.7086 5.34743 17.5733L11.9468 10.9726C12.7346 11.2343 13.5785 11.278 14.3891 11.0991C15.1997 10.9203 15.9468 10.5255 16.5514 9.95667C17.1559 9.38781 17.5954 8.66602 17.8232 7.86776C18.0511 7.06949 18.0588 6.22446 17.8456 5.42217C17.6274 4.59842 16.6626 4.51637 16.1785 5.00045L14.7649 6.41329C14.688 6.49317 14.5959 6.55692 14.4941 6.6008C14.3923 6.64468 14.2827 6.66782 14.1718 6.66887C14.0609 6.66991 13.9509 6.64884 13.8483 6.60688C13.7456 6.56493 13.6524 6.50293 13.574 6.42451C13.4956 6.34609 13.4336 6.25283 13.3916 6.15017C13.3497 6.04752 13.3286 5.93753 13.3296 5.82663C13.3307 5.71574 13.3538 5.60616 13.3977 5.50431C13.4416 5.40247 13.5053 5.31039 13.5852 5.23346L14.9979 3.8198C15.482 3.33572 15.3999 2.37085 14.5754 2.15261C14.1904 2.05083 13.7939 1.99953 13.3957 2",fill:"currentColor"})}),label:"ferramentas"},{id:"food",icon:f("svg",{xmlns:"http://www.w3.org/2000/svg",width:"20",height:"20",viewBox:"0 0 20 20",fill:"none",children:f("path",{d:"M14.4073 18H15.6145C16.2255 18 16.7273 17.5273 16.8 16.9309L18 4.94545H14.3636V2H12.9309V4.94545H9.31636L9.53455 6.64727C10.7782 6.98909 11.9418 7.60727 12.64 8.29091C13.6873 9.32364 14.4073 10.3927 14.4073 12.1382V18ZM2 17.2727V16.5455H12.9309V17.2727C12.9309 17.6655 12.6036 18 12.1818 18H2.72727C2.32727 18 2 17.6655 2 17.2727ZM12.9309 12.1818C12.9309 6.36364 2 6.36364 2 12.1818H12.9309ZM2 13.6364H12.9091V15.0909H2V13.6364Z",fill:"currentColor"})}),label:"comidas"},{id:"job",icon:f("svg",{xmlns:"http://www.w3.org/2000/svg",width:"16",height:"13",viewBox:"0 0 16 13",fill:"none",children:f("path",{d:"M11.2 2.29412H12.8V13H3.2V2.29412H4.8V1.52941C4.8 1.12379 4.96857 0.734775 5.26863 0.447954C5.56869 0.161134 5.97565 0 6.4 0H9.6C10.0243 0 10.4313 0.161134 10.7314 0.447954C11.0314 0.734775 11.2 1.12379 11.2 1.52941V2.29412ZM13.6 2.29412H14.4C14.8243 2.29412 15.2313 2.45525 15.5314 2.74207C15.8314 3.02889 16 3.4179 16 3.82353V11.4706C16 11.8762 15.8314 12.2652 15.5314 12.552C15.2313 12.8389 14.8243 13 14.4 13H13.6V2.29412ZM2.4 2.29412V13H1.6C1.17565 13 0.768687 12.8389 0.468629 12.552C0.168571 12.2652 0 11.8762 0 11.4706V3.82353C0 2.98235 0.72 2.29412 1.6 2.29412H2.4ZM6.4 1.52941V2.29412H9.6V1.52941H6.4Z",fill:"currentColor"})}),label:"items de trabalho"}];function tP(){const{filter:e,setFilter:t}=Et();return f(Z7,{children:eP.map(n=>f(J7,{active:e===n.id,onClick:()=>{t(n.id)},children:n.icon},n.id))})}function r0({items:e,name:t,label:n,type:r,slots:o,weight:i,isMain:s}){const{t:a}=Zt(),{theme:l}=Ay(),{filter:c}=Et(),u=v.exports.useMemo(()=>new Array(r==="main"?o-5:o).fill(0),[r,o]),p=(n==null?void 0:n.trim())||(t!=null?t:a(`title.${r}`)),y=v.exports.useMemo(()=>{const x=l.tag==="fronteira",b=["chest","trunk","inspect"].includes(r);return c==="all"||!b||!x?e:e.filter(g=>{var I,O,L,_,re;const h=((I=g.type)==null?void 0:I.toLowerCase())||"",m=((O=g.class)==null?void 0:O.toLowerCase())||"";(L=g.name)!=null&&L.toLowerCase();const S=((_=g.index)==null?void 0:_.toLowerCase())||"",E=h.includes("arma")||h.includes("muni")||h.includes("throwing")||m.includes("armas"),T=m.includes("comida");switch(c){case"weapon":return E;case"food":return T;case"tool":return(h.includes("comum")||m.includes("utilitarios")||m.includes("premium"))&&!E&&!T;case"job":const J=h.includes("us\xE1vel")||h.includes("usavel");return m.includes("droga")||m.includes("medicamento")||m.includes("halloween")||J&&!E&&!T||!!((re=g.custom)!=null&&re.suitcase)||h.includes("maleta")||S.includes("maleta");default:return!0}})},[e,c]),w=x=>{let b=x;r==="main"&&(b=x+5);const g=y.find(h=>h.slot===b);return g!=null?g:{slot:b}};return P($5,{children:[P(L5,{children:[f(N5,{children:p}),i&&P(X7,{children:[Ao(i.current)," ",P("span",{children:["| ",Ao(i.max),"kg"]})]})]}),f(R5,{percentage:i?i.current/i.max*100:0}),P(q7,{children:[f(_5,{type:r,children:u.map((x,b)=>f(M5,{item:w(b+1),type:r,isMain:s},`${r}-${b}`))}),["chest","trunk","inspect"].includes(r)&&l.tag==="fronteira"&&f(tP,{})]})]})}const nP=C.div`
  display: flex;
  height: max-content;
  gap: var(--slot-gap);
  position: relative;
  flex-direction: column;
  grid-area: 2 / 1 / 3 / 2;
  margin-top: var(--inventory-header-height);
`,rP=C.div`
  display: flex;
  transform: rotate(-90deg);

  font-family: 'Poppins', sans-serif;
  font-weight: 600;
  font-size: 1.2rem;
  color: #FFFFFF;

  text-transform: uppercase;
  height: max-content;
  width: 100%;
  position: absolute;
  right: 85%;
  top: 85%;

  &::before {
    content: '';
    width: 22rem;
    height: .2rem;
    background: linear-gradient(90deg, ${({theme:e})=>e.colors.main[500]} 0%, rgba(0, 0, 0, 0) 100%);
    border-radius: 0.1vw;
    margin-right: 10px;
    position: absolute;
    top: 50%;
    left: 120%;
    transform: translateY(-50%);
  }
`;function oP(){const{t:e}=Zt(),{hotbarItems:t}=Et(),[n]=v.exports.useState(new Array(5).fill(0)),r=o=>{const i=t.find(s=>s.slot===o);return i!=null?i:{slot:o}};return P(nP,{children:[f(rP,{children:e("title.hotbar")}),n.map((o,i)=>f(M5,{item:r(i+1),type:"hotbar"},`hotbar-${i}`))]})}const F5=C(bl.div)`
  display: flex;
  align-items: center;
  justify-content: flex-end;
  width: 100%;
  height: 100%;
  grid-area: 1 / 2 / 2 / 3;
  opacity: 0;
`,iP=C(bl.div)`
  width: 100%;
  height: 100%;

  background: linear-gradient(89.02deg, ${({theme:e})=>e.colors.main[500]} 0.52%, rgba(0, 0, 0, 0) 103.28%);
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 2.3rem;
  grid-area: 1 / 2 / 2 / 3;
`;C.div`
  display: flex;
  gap: 1rem;
  align-items: center;
  justify-content: space-between;
  width: 43.3%;
  height: 100%;
`;const z5=C.button`
  background: ${({theme:e})=>e.colors["main-opacity"][800]};
  border-radius: .2rem;
  border: none;
  cursor: pointer;
  font-size: 1rem;
  color: #FFFFFF;
  transition: .3s;
  padding: .5rem 1.9rem;
  font-weight: 500;

  &:hover {
    background: ${({theme:e})=>e.colors["main-opacity"][500]};
  }
`,sP=C.span`
  font-weight: 600;
  font-size: 1.4rem;
  color: #FFFFFF;
`,V5=C.img`
  width: 9.5rem;
  height: 6.75rem;
  object-fit: contain;
  margin-bottom: 1.5rem;
`,aP=C.div`
  width: 43.3%;
  height: 100%;

  background: linear-gradient(89.02deg, ${({theme:e})=>e.colors.main[500]} 0.52%, rgba(242, 10, 69, 0) 103.28%);
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 0.3rem;
`,lP="https://santaimagens.roleplayrp.com/img/imagens_variadas/bag.png",cP="https://santaimagens.roleplayrp.com/img/imagens_variadas/bagSmall.png";function o0(){const{t:e}=Zt(),{secondaryInventory:t}=Et();return f(F5,{initial:{opacity:0,y:-50},animate:{opacity:1,y:0},exit:{opacity:0,y:-50},transition:{duration:.3},children:P(aP,{children:[f(V5,{src:lP}),f(z5,{style:{padding:".5rem 1.4rem"},onClick:()=>{t!=null&&t.type&&Oe(tk[t==null?void 0:t.type])},children:e("upgradeInventoryButton")})]})})}function uP(){const{t:e}=Zt(),t=()=>{Oe("requestUpgradeMain")};return f(F5,{initial:{opacity:0,y:-50},animate:{opacity:1,y:0},exit:{opacity:0,y:-50},transition:{duration:.3},children:P(iP,{children:[f(V5,{src:cP}),f(sP,{children:e("upgradeInventoryTitle")}),f(z5,{onClick:t,children:e("upgradeInventoryButton")})]})})}function dP(){const{secondaryInventory:e}=Et();if(!e)return null;switch(e.type){case"chest":return f(o0,{});case"property":return f(o0,{});case"inspect":return null;case"shop":return null;case"trunk":return null;case void 0:return null;default:return f(uP,{})}}const fP=()=>{var d;const{currentAmount:e}=Et(),n=Nr().getMonitor(),[r,o]=v.exports.useState(null),i=v.exports.useCallback(()=>{o(n.getItem())},[n]);v.exports.useEffect(()=>n.subscribeToStateChange(i),[n,i]);const s=v.exports.useRef(null),a=v.exports.useCallback(()=>{if(s.current){const p=n.getSourceClientOffset();p?(s.current.style.left=`${p.x}px`,s.current.style.top=`${p.y}px`,s.current.style.opacity="1"):s.current.style.opacity="0"}},[n]);if(v.exports.useEffect(()=>n.subscribeToOffsetChange(a),[n,a]),!r)return f(pe,{});const{item:l,type:c}=r,u=r.source&&(d=l==null?void 0:l.amount)!=null?d:e;return f(Hf,{type:"preview",secondType:c,isItem:Nt(l),ref:s,children:Nt(l)&&f(pe,{children:f(Zf,{item:{...l,amount:u},inventoryType:c})})})},hP=C.div`
  position: absolute;
  width: 100%;
  height: 100%;
  z-index: -1;

  div.background1 {
    position: absolute;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, rgba(0, 0, 0, 0.75) 0%, rgba(0, 0, 0, 0.25 ) 100%);
  }

  div.elipse1 {
    position: absolute;
    top: -10vw;
    left: -10vw;
    height: 55vw;
    width: 55vw;
    
    background: ${({theme:e})=>`radial-gradient(49.95% 49.95% at 49.95% 50.05%, ${e.colors["main-opacity"][300]} 24.48%, rgba(0, 0, 0, 0.00) 100%)`};
  }

  div.elipse2 {
    position: absolute;
    bottom: -27.5vw;
    left: 0vw;
    height: 55vw;
    width: 55vw;
    
    background: ${({theme:e})=>`radial-gradient(49.95% 49.95% at 49.95% 50.05%, ${e.colors["main-opacity"][300]} 24.48%, rgba(0, 0, 0, 0.00) 100%)`};
  }

  div.background2 {
    position: absolute;
    width: 100%;
    height: 100%;
    background: ${({theme:e})=>`linear-gradient(90deg, ${e.colors["main-opacity"][500]} 0%, ${e.colors["main-opacity"][200]} 100%)`};
  }
`;function pP(){return P(hP,{children:[f("div",{className:"background1"}),f("div",{className:"elipse1"}),f("div",{className:"elipse2"}),f("div",{className:"background2"})]})}const mP=C.div`
  width: 100%;
  height: 100%;
  display: grid;
  grid-template-columns: calc((4 * var(--slot-width)) + (var(--slot-gap) * 3)) 6vw max-content;
  grid-area: 2 / 2 / 3 / 3;
`,gP=C.div`
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: column;
  min-width: var(--slot-width);
  height: var(--slot-height);

  background: rgba(0, 0, 0, 0.3);
  border-radius: .2rem;
  justify-content: space-between;

  position: relative;

  transition: all .2s;

  @keyframes loading {
    0% {
      background: rgba(0, 0, 0, 0.3);
    }
    50% {
      background: rgba(0, 0, 0, 0.5);
    }
    100% {
      background: rgba(0, 0, 0, 0.3);
    }
  }

  animation: loading 1s infinite ${e=>e.index%4*.1}s;
`;function i0(){const e=new Array(50).fill(0),{t}=Zt();return P($5,{children:[f(L5,{children:f(N5,{children:t("loading")})}),f(R5,{percentage:0}),f(_5,{children:e.map((n,r)=>f(gP,{index:r},r))})]})}function yP(e){return Ae({tag:"svg",attr:{viewBox:"0 0 24 24",fill:"none",stroke:"currentColor",strokeWidth:"2",strokeLinecap:"round",strokeLinejoin:"round"},child:[{tag:"line",attr:{x1:"19",y1:"12",x2:"5",y2:"12"}},{tag:"polyline",attr:{points:"12 19 5 12 12 5"}}]})(e)}function j5(e){return Ae({tag:"svg",attr:{viewBox:"0 0 24 24",fill:"none",stroke:"currentColor",strokeWidth:"2",strokeLinecap:"round",strokeLinejoin:"round"},child:[{tag:"path",attr:{d:"M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"}},{tag:"polyline",attr:{points:"3.27 6.96 12 12.01 20.73 6.96"}},{tag:"line",attr:{x1:"12",y1:"22.08",x2:"12",y2:"12"}}]})(e)}function vP(e){return Ae({tag:"svg",attr:{viewBox:"0 0 24 24",fill:"none",stroke:"currentColor",strokeWidth:"2",strokeLinecap:"round",strokeLinejoin:"round"},child:[{tag:"polyline",attr:{points:"20 6 9 17 4 12"}}]})(e)}function B5(e){return Ae({tag:"svg",attr:{viewBox:"0 0 24 24",fill:"none",stroke:"currentColor",strokeWidth:"2",strokeLinecap:"round",strokeLinejoin:"round"},child:[{tag:"polyline",attr:{points:"6 9 12 15 18 9"}}]})(e)}function U5(e){return Ae({tag:"svg",attr:{viewBox:"0 0 24 24",fill:"none",stroke:"currentColor",strokeWidth:"2",strokeLinecap:"round",strokeLinejoin:"round"},child:[{tag:"circle",attr:{cx:"12",cy:"12",r:"10"}},{tag:"polyline",attr:{points:"12 6 12 12 16 14"}}]})(e)}function s0(e){return Ae({tag:"svg",attr:{viewBox:"0 0 24 24",fill:"none",stroke:"currentColor",strokeWidth:"2",strokeLinecap:"round",strokeLinejoin:"round"},child:[{tag:"circle",attr:{cx:"12",cy:"12",r:"10"}},{tag:"line",attr:{x1:"12",y1:"16",x2:"12",y2:"12"}},{tag:"line",attr:{x1:"12",y1:"8",x2:"12.01",y2:"8"}}]})(e)}function H5(e){return Ae({tag:"svg",attr:{viewBox:"0 0 24 24",fill:"none",stroke:"currentColor",strokeWidth:"2",strokeLinecap:"round",strokeLinejoin:"round"},child:[{tag:"path",attr:{d:"M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"}},{tag:"circle",attr:{cx:"12",cy:"10",r:"3"}}]})(e)}function xP(e){return Ae({tag:"svg",attr:{viewBox:"0 0 24 24",fill:"none",stroke:"currentColor",strokeWidth:"2",strokeLinecap:"round",strokeLinejoin:"round"},child:[{tag:"line",attr:{x1:"5",y1:"12",x2:"19",y2:"12"}}]})(e)}function wP(e){return Ae({tag:"svg",attr:{viewBox:"0 0 24 24",fill:"none",stroke:"currentColor",strokeWidth:"2",strokeLinecap:"round",strokeLinejoin:"round"},child:[{tag:"line",attr:{x1:"19",y1:"5",x2:"5",y2:"19"}},{tag:"circle",attr:{cx:"6.5",cy:"6.5",r:"2.5"}},{tag:"circle",attr:{cx:"17.5",cy:"17.5",r:"2.5"}}]})(e)}function a0(e){return Ae({tag:"svg",attr:{viewBox:"0 0 24 24",fill:"none",stroke:"currentColor",strokeWidth:"2",strokeLinecap:"round",strokeLinejoin:"round"},child:[{tag:"line",attr:{x1:"12",y1:"5",x2:"12",y2:"19"}},{tag:"line",attr:{x1:"5",y1:"12",x2:"19",y2:"12"}}]})(e)}function rd(e){return Ae({tag:"svg",attr:{viewBox:"0 0 24 24",fill:"none",stroke:"currentColor",strokeWidth:"2",strokeLinecap:"round",strokeLinejoin:"round"},child:[{tag:"path",attr:{d:"M18.36 6.64a9 9 0 1 1-12.73 0"}},{tag:"line",attr:{x1:"12",y1:"2",x2:"12",y2:"12"}}]})(e)}function l0(e){return Ae({tag:"svg",attr:{viewBox:"0 0 24 24",fill:"none",stroke:"currentColor",strokeWidth:"2",strokeLinecap:"round",strokeLinejoin:"round"},child:[{tag:"circle",attr:{cx:"11",cy:"11",r:"8"}},{tag:"line",attr:{x1:"21",y1:"21",x2:"16.65",y2:"16.65"}}]})(e)}function bP(e){return Ae({tag:"svg",attr:{viewBox:"0 0 24 24",fill:"none",stroke:"currentColor",strokeWidth:"2",strokeLinecap:"round",strokeLinejoin:"round"},child:[{tag:"circle",attr:{cx:"12",cy:"12",r:"3"}},{tag:"path",attr:{d:"M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"}}]})(e)}function CP(e){return Ae({tag:"svg",attr:{viewBox:"0 0 24 24",fill:"none",stroke:"currentColor",strokeWidth:"2",strokeLinecap:"round",strokeLinejoin:"round"},child:[{tag:"path",attr:{d:"M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"}},{tag:"line",attr:{x1:"7",y1:"7",x2:"7.01",y2:"7"}}]})(e)}function c0(e){return Ae({tag:"svg",attr:{viewBox:"0 0 24 24",fill:"none",stroke:"currentColor",strokeWidth:"2",strokeLinecap:"round",strokeLinejoin:"round"},child:[{tag:"polyline",attr:{points:"3 6 5 6 21 6"}},{tag:"path",attr:{d:"M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"}},{tag:"line",attr:{x1:"10",y1:"11",x2:"10",y2:"17"}},{tag:"line",attr:{x1:"14",y1:"11",x2:"14",y2:"17"}}]})(e)}function SP(e){return Ae({tag:"svg",attr:{viewBox:"0 0 24 24",fill:"none",stroke:"currentColor",strokeWidth:"2",strokeLinecap:"round",strokeLinejoin:"round"},child:[{tag:"path",attr:{d:"M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"}},{tag:"circle",attr:{cx:"8.5",cy:"7",r:"4"}},{tag:"line",attr:{x1:"18",y1:"8",x2:"23",y2:"13"}},{tag:"line",attr:{x1:"23",y1:"8",x2:"18",y2:"13"}}]})(e)}function fo(e){return Ae({tag:"svg",attr:{viewBox:"0 0 24 24",fill:"none",stroke:"currentColor",strokeWidth:"2",strokeLinecap:"round",strokeLinejoin:"round"},child:[{tag:"path",attr:{d:"M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"}},{tag:"circle",attr:{cx:"9",cy:"7",r:"4"}},{tag:"path",attr:{d:"M23 21v-2a4 4 0 0 0-3-3.87"}},{tag:"path",attr:{d:"M16 3.13a4 4 0 0 1 0 7.75"}}]})(e)}function Ws(e){return Ae({tag:"svg",attr:{viewBox:"0 0 24 24",fill:"none",stroke:"currentColor",strokeWidth:"2",strokeLinecap:"round",strokeLinejoin:"round"},child:[{tag:"circle",attr:{cx:"12",cy:"12",r:"10"}},{tag:"line",attr:{x1:"15",y1:"9",x2:"9",y2:"15"}},{tag:"line",attr:{x1:"9",y1:"9",x2:"15",y2:"15"}}]})(e)}var kP="./assets/l85.12a3a70b.png",PP="./assets/mushroomtea.e49479d4.png",TP="./assets/background.a6a23804.png";const EP=C.div`
  position: fixed;
  inset: 0;
  overflow: hidden;
  color: #ffffff;
  background: ${({$devBackground:e})=>e?`#080d0f url(${TP}) center center / cover no-repeat`:"transparent"};

  &::before,
  &::after {
    content: '';
    position: absolute;
    inset: 0;
    pointer-events: none;
  }

  &::before {
    background: rgba(5, 9, 11, 0.5);
  }

  &::after {
    background:
      ${({theme:e})=>`linear-gradient(90deg, ${e.colors["main-opacity"][500]} 0%, ${e.colors["main-opacity"][300]} 29%, ${e.colors["main-opacity"][200]} 61%, rgba(5, 9, 11, 0) 100%)`},
      linear-gradient(90deg, rgba(20, 20, 20, 0.9) 0%, rgba(20, 20, 20, 0.4) 50%, rgba(20, 20, 20, 0) 100%);
  }
`,IP=C.div`
  position: relative;
  z-index: 1;
  width: 100%;
  height: 100%;
`,OP=C.header`
  position: absolute;
  top: 2.5rem;
  left: 3rem;
  width: 33rem;
  display: flex;
  flex-direction: column;
  gap: 0.125rem;
`,AP=C.h1`
  font-size: 1.75rem;
  font-weight: 600;
  line-height: 1.25;
  color: #ffffff;
`,DP=C.p`
  font-size: 0.9375rem;
  font-weight: 400;
  color: rgba(255, 255, 255, 0.7);
  white-space: pre-wrap;
`,MP=C.main`
  position: absolute;
  left: ${({$role:e})=>e==="seller"?"4.875rem":"4.625rem"};
  top: ${({$role:e})=>e==="seller"?"12.5rem":"16.375rem"};
  display: flex;
  align-items: flex-start;
  gap: ${({$role:e})=>e==="seller"?"1rem":"1.25rem"};
`,u0=C.div`
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
  margin-left: 0;
`,Sc=C.section`
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  width: ${({$width:e})=>e!=null?e:"auto"};
  gap: 1rem;
`,d0=C.div`
  display: flex;
  align-items: center;
  justify-content: space-between;
  width: 100%;
  overflow: hidden;
  white-space: nowrap;
`,Go=C.h2`
  font-size: 1.25rem;
  font-weight: 600;
  line-height: 1.25;
  color: #ffffff;
`,f0=C.span`
  font-size: 0.9375rem;
  font-weight: 500;
  color: rgba(255, 255, 255, 0.85);
`,Ko=C.div`
  height: 0.1875rem;
  width: 100%;
  flex: none;
  background: linear-gradient(90deg, ${({theme:e})=>e.colors.main[500]} 0%, rgba(0, 0, 0, 0) 100%);
`,RP=C.div`
  display: grid;
  grid-template-columns: repeat(4, 4.75rem);
  gap: 0.625rem;
`,$P=C.div`
  display: grid;
  grid-template-columns: repeat(6, 4.75rem);
  gap: 0.625rem;
`,LP=C.div`
  display: grid;
  grid-template-columns: repeat(3, 7.5625rem);
  gap: 0.87825rem;
  width: 24.445rem;
`,NP=C.div`
  position: relative;
  overflow: hidden;
  flex: none;
  border-radius: ${({$variant:e})=>e==="buyerOffer"?"0.29275rem":"0.25rem"};
  background: ${({$isOver:e,theme:t})=>e?t.colors["main-opacity"][200]:"rgba(0, 0, 0, 0.58)"};
  border: 1px solid ${({$isOver:e,theme:t})=>e?t.colors.main[500]:"transparent"};
  cursor: ${({$isItem:e})=>e?"grab":"default"};
  opacity: ${({$isDragging:e})=>e?.35:1};
  transition: background 0.15s ease, border-color 0.15s ease, opacity 0.15s ease;

  ${({$variant:e})=>e==="buyerOffer"?de`
        width: 7.5625rem;
        height: 7.5625rem;
      `:de`
        width: 4.75rem;
        height: 5.5rem;
      `}
`,_P=C.img`
  position: absolute;
  left: 50%;
  top: ${({$variant:e})=>e==="buyerOffer"?"47%":"45%"};
  width: ${({$variant:e})=>e==="buyerOffer"?"89%":"100%"};
  height: ${({$variant:e})=>e==="buyerOffer"?"89%":"86%"};
  object-fit: contain;
  transform: translate(-50%, -50%);
  pointer-events: none;
`,FP=C.div`
  position: absolute;
  top: ${({$large:e})=>e?"0.5855rem":"0.25rem"};
  left: ${({$large:e})=>e?"0.5855rem":"0.375rem"};
  right: ${({$large:e})=>e?"0.5855rem":"0.375rem"};
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: ${({$large:e})=>e?"0.87825rem":"0.5rem"};
  font-weight: 400;
  color: rgba(255, 255, 255, 0.55);
  line-height: 1;
  z-index: 2;
`,zP=C.div`
  position: absolute;
  left: 0;
  right: 0;
  bottom: 0;
  height: ${({$large:e})=>e?"1.614rem":"0.9375rem"};
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0 0.35rem;
  background: rgba(0, 0, 0, 0.58);
  color: ${({$strong:e})=>e?"rgba(255, 255, 255, 0.85)":"rgba(255, 255, 255, 0.5)"};
  font-size: ${({$large:e})=>e?"0.87825rem":"0.5625rem"};
  font-weight: 400;
  text-align: center;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  z-index: 2;
`,VP=C.div`
  position: absolute;
  left: 0;
  bottom: ${({$large:e})=>e?"1.614rem":"0.9375rem"};
  width: 0.1875rem;
  height: ${({$large:e})=>e?"calc(100% - 1.614rem)":"calc(100% - 0.9375rem)"};
  display: flex;
  align-items: flex-end;
  background: rgba(0, 0, 0, 0.4);
  z-index: 2;
`,jP=C.div`
  width: 100%;
  height: ${({$percent:e})=>e<=0?100:e}%;
  background: ${({$color:e})=>e};
  box-shadow: ${({$color:e})=>e!=="transparent"?`0 0 0.4375rem ${e}`:"none"};
`,h0=C.div`
  display: flex;
  align-items: center;
  gap: 0.5rem;
  min-height: 1rem;
  color: rgba(255, 255, 255, 0.55);
  font-size: 0.75rem;
  font-weight: 400;
  white-space: nowrap;
`,p0=C.span`
  width: 1rem;
  height: 1rem;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  border: 1px solid rgba(255, 255, 255, 0.26);
  color: rgba(255, 255, 255, 0.6);
  font-size: 0.625rem;
  line-height: 1;
`,BP=C.div`
  width: 20.25rem;
  min-height: 3rem;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
  padding: 0 1rem;
  border-radius: 0.25rem;
  border: 1px solid rgba(255, 255, 255, 0.06);
  background: rgba(0, 0, 0, 0.52);
`,UP=C.span`
  min-width: 0;
  color: rgba(255, 255, 255, 0.86);
  font-size: 0.8125rem;
  font-weight: 600;
  line-height: 1;
  white-space: nowrap;
`,HP=C.div`
  flex: none;
  display: flex;
  align-items: center;
  gap: 1.125rem;
`,m0=C.button`
  display: inline-flex;
  align-items: center;
  gap: 0.4375rem;
  padding: 0;
  border: 0;
  background: transparent;
  color: ${({$active:e,theme:t})=>e?t.colors.main[500]:"rgba(255, 255, 255, 0.62)"};
  font-size: 0.8125rem;
  font-weight: 600;
  line-height: 1;
  white-space: nowrap;
  transition:
    color 0.15s ease,
    filter 0.15s ease;

  &:hover {
    filter: brightness(1.08);
  }
`,g0=C.span`
  width: 0.9375rem;
  height: 0.9375rem;
  flex: none;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: 0.1875rem;
  border: 1px solid ${({$active:e,theme:t})=>e?t.colors.main[500]:"rgba(255, 255, 255, 0.2)"};
  background: ${({$active:e,theme:t})=>e?t.colors.main[500]:"rgba(255, 255, 255, 0.04)"};
  transition:
    background 0.15s ease,
    border-color 0.15s ease;

  &::after {
    content: "";
    width: 0.4375rem;
    height: 0.25rem;
    margin-top: -0.0625rem;
    border-left: 0.125rem solid #0a0d11;
    border-bottom: 0.125rem solid #0a0d11;
    opacity: ${({$active:e})=>e?1:0};
    transform: rotate(-45deg);
  }
`,WP=C.label`
  width: 5.25rem;
  height: 2.25rem;
  margin-top: 4.0625rem;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 0.25rem;
  background: rgba(0, 0, 0, 0.58);
  color: rgba(255, 255, 255, 0.5);
  font-size: 0.75rem;
  font-weight: 500;
`,GP=C.input`
  width: 100%;
  height: 100%;
  border: 0;
  background: transparent;
  color: rgba(255, 255, 255, 0.65);
  text-align: center;
  font-size: 0.75rem;
  font-weight: 500;
  text-transform: uppercase;

  &::placeholder {
    color: rgba(255, 255, 255, 0.5);
  }
`,y0=C.section`
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: ${({$role:e})=>e==="seller"?"1.375rem":"1.5rem"};
  width: ${({$role:e})=>e==="seller"?"20.25rem":"24.445rem"};
`,kc=C.label`
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  width: 100%;
`,Pc=C.span`
  color: rgba(255, 255, 255, 0.6);
  font-size: 0.8125rem;
  font-weight: 400;
`,Tc=C.div`
  width: 100%;
  min-height: ${({$large:e})=>e?"4rem":"3.25rem"};
  display: flex;
  align-items: center;
  gap: ${({$large:e})=>e?"0.5rem":"0.625rem"};
  padding: ${({$large:e})=>e?"1rem":"0 1rem"};
  border-radius: 0.25rem;
  border: 1px solid ${({$readonly:e})=>e?"rgba(255, 255, 255, 0.06)":"rgba(255, 255, 255, 0.12)"};
  background: ${({$readonly:e})=>e?"rgba(0, 0, 0, 0.4)":"rgba(0, 0, 0, 0.6)"};
`,Ec=C.span`
  color: ${({$muted:e,theme:t})=>e?"rgba(255, 255, 255, 0.4)":t.colors.main[500]};
  font-size: ${({$large:e})=>e?"1.3536rem":"1.0625rem"};
  font-weight: 500;
`,v0=C.input`
  flex: 1;
  min-width: 0;
  border: 0;
  background: transparent;
  color: ${({$muted:e})=>e?"rgba(255, 255, 255, 0.4)":"#ffffff"};
  font-size: ${({$large:e})=>e?"1.274rem":"1rem"};
  font-weight: 500;
`,KP=C.span`
  color: ${({$muted:e})=>e?"rgba(255, 255, 255, 0.4)":"#ffffff"};
  font-size: ${({$large:e})=>e?"1.274rem":"1rem"};
  font-weight: 500;
`,YP=C.div`
  display: flex;
  align-items: center;
  gap: 0.375rem;
  min-height: 1rem;
  color: rgba(255, 255, 255, 0.52);
  font-size: 0.75rem;
  font-weight: 500;
  line-height: 1.2;
  white-space: nowrap;
`,QP=C.span`
  width: 0.875rem;
  height: 0.875rem;
  flex: none;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  border: 1px solid rgba(255, 255, 255, 0.26);
  color: rgba(255, 255, 255, 0.58);

  svg {
    width: 0.5625rem;
    height: 0.5625rem;
  }
`,XP=C.strong`
  color: ${({theme:e})=>e.colors.main[500]};
  font-size: 0.75rem;
  font-weight: 700;
`,qP=C.div`
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 0.625rem;
  padding: 0.75rem;
  border-radius: 0.25rem;
  border: 1px solid rgba(255, 255, 255, 0.06);
  background: rgba(0, 0, 0, 0.4);
`,x0=C.div`
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
  width: 100%;
  color: rgba(255, 255, 255, 0.4);
  font-size: 0.875rem;
  font-weight: 500;
`,Ic=C.span`
  color: ${({theme:e})=>e.colors.main[500]};
  font-size: 1rem;
  font-weight: 500;
`,ZP=C.div`
  width: 100%;
  height: 1px;
  background: rgba(255, 255, 255, 0.16);
`,w0=C.div`
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: ${({$match:e})=>e?"#34c759":"#ffb800"};
  font-size: 0.8125rem;
  font-weight: 500;
  white-space: nowrap;
`,b0=C.span`
  width: 0.625rem;
  height: 0.625rem;
  border-radius: 50%;
  background: ${({$match:e})=>e?"#34c759":"#ffb800"};
  box-shadow: 0 0 0.4rem ${({$match:e})=>e?"rgba(52, 199, 89, 0.6)":"rgba(255, 184, 0, 0.6)"};
`,C0=C.div`
  display: flex;
  align-items: center;
  gap: 1rem;
`,Ps=C.button`
  height: 3.5rem;
  min-width: ${({$primary:e})=>e?"7.5rem":"5.375rem"};
  padding: 0 2.5rem;
  border: 0;
  border-radius: 0.375rem;
  background: ${({$primary:e,theme:t})=>e?t.colors.main[500]:"rgba(23, 26, 28, 0.9)"};
  color: #ffffff;
  font-size: 0.9375rem;
  font-weight: 600;
  white-space: nowrap;
  transition: filter 0.15s ease, opacity 0.15s ease;

  &:disabled {
    cursor: default;
    opacity: 0.45;
  }

  &:not(:disabled):hover {
    filter: brightness(1.08);
  }
`,JP=C.p`
  width: 24.445rem;
  color: rgba(255, 255, 255, 0.55);
  font-size: 0.8125rem;
  font-weight: 400;
  line-height: 1.45;
`,eT=C.div`
  width: 100%;
  padding: 0.75rem;
  border-radius: 0.25rem;
  border: 1px solid rgba(255, 255, 255, 0.12);
  background: rgba(0, 0, 0, 0.6);
`,tT=C.div`
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
  color: rgba(255, 255, 255, 0.4);
  font-size: 0.875rem;
  font-weight: 500;
  white-space: nowrap;
`,nT=C.footer`
  position: absolute;
  left: 3rem;
  bottom: 2.375rem;
  display: flex;
  align-items: center;
  gap: 1.125rem;
`,S0=C.div`
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: ${({$state:e})=>e==="confirmed"?"#ffffff":"#ffb800"};
  font-size: 0.9375rem;
  font-weight: 500;
  white-space: nowrap;
`,k0=C.span`
  width: 1.125rem;
  height: 1.125rem;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  border: ${({$state:e})=>e==="confirmed"?"0":"1px solid #ffb800"};
  background: ${({$state:e})=>e==="confirmed"?"#34c759":"transparent"};
  color: ${({$state:e})=>e==="confirmed"?"#ffffff":"#ffb800"};
  font-size: 0.6875rem;
  line-height: 1;
`,rT=C.div`
  width: 1px;
  height: 1.25rem;
  background: rgba(255, 255, 255, 0.25);
`,P0="faction-trade-item",oT=()=>Array.from({length:24},(e,t)=>({slot:t+1,key:"mushroomtea",index:"mushroomtea",name:"Ch\xE1 de Cogum.",desc:"Item reservado para negocia\xE7\xE3o.",amount:10,weight:2,type:"Comum",class:"Utilitarios",days:1,durability:8e4,image:PP})),iT=e=>{const t=e==="buyer"?4:2;return Array.from({length:t},(n,r)=>({slot:r+1,key:"WEAPON_L85",index:"WEAPON_L85",name:"Fuzil",desc:"Armamento ofertado na negocia\xE7\xE3o.",amount:1,weight:e==="buyer"?2:2.8,type:"Armamento",class:"Armas",image:kP,sourceSlot:r+1}))},od=e=>({role:e,seller:{name:"Carlos",id:304,confirmed:!1},buyer:{name:"Jo\xE3o Silva",id:152,confirmed:!0},stock:{items:oT(),slots:24,weight:{current:275,max:1150}},offer:{items:iT(e),slots:e==="buyer"?9:12,weight:{current:275,max:1150}},price:15e3,buyerValue:15e3,valuesMatch:!0,hasPartnership:pt()?!0:null,commission:{enabled:!0,percentage:15,amount:2250},sellerConfirmed:!1,buyerConfirmed:!0,canConfirm:!0}),sT=e=>{const t=(e!=null?e:"").toLowerCase();return t.includes("buyer")||t.includes("comprador")?"buyer":"seller"},Oc=(e,t)=>{var r,o,i,s,a,l,c;const n=od(t);return e?{...n,...e,role:(r=e.role)!=null?r:t,seller:{...n.seller,...e.seller},buyer:{...n.buyer,...e.buyer},stock:{...n.stock,...e.stock,items:(a=(s=(o=e.stock)==null?void 0:o.items)!=null?s:(i=n.stock)==null?void 0:i.items)!=null?a:[]},offer:{...n.offer,...e.offer,items:(c=(l=e.offer)==null?void 0:l.items)!=null?c:n.offer.items},hasPartnership:Object.prototype.hasOwnProperty.call(e,"hasPartnership")?e.hasPartnership:n.hasPartnership,commission:e.commission}:n},aT=e=>({...e,sellerConfirmed:!1,buyerConfirmed:!1,seller:{...e.seller,confirmed:!1},buyer:{...e.buyer,confirmed:!1}}),Ac=e=>Array.from({length:e},(t,n)=>n+1),lT=e=>{var t,n;return(n=e.image)!=null?n:nn(String((t=e.key)!=null?t:e.index))},cT=(e,t)=>t==="buyerOffer"&&(e.type||e.class)||e.name,uT=(e,t)=>{var r;const n=Number((r=e.weight)!=null?r:0).toFixed(1);return t==="sellerOffer"?`${n}kg`:n},dT=e=>`${Ao(e)}x`;function fT({item:e,large:t}){var i;const n=(i=e.durability)!=null?i:e.Durability;if(n===void 0||e.days===void 0||e.days<0)return f(pe,{});const r=jf(e.days,n),o=p5(e.days,n);return f(VP,{$large:t,children:f(jP,{$percent:r,$color:o})})}const ur=e=>Uf(e||0),T0=e=>Number(e.replace(/\D/g,""))||0,hT=e=>{const t=e.commission;if(!t||t.enabled===!1||t.percentage===void 0||t.percentage===null)return;const n=Number(t.percentage);if(!Number.isFinite(n)||n<=0)return;const r=typeof t.amount=="number"&&Number.isFinite(t.amount)?t.amount:Math.floor(e.price*n/100);return{percentage:n,amount:r,message:t.message}},ln=(e,t)=>{Oe(e,t)};function Dc({slot:e,item:t,source:n,variant:r,draggable:o,removable:i,droppable:s,dragAmount:a,canDropItem:l,onDropItem:c,onRemove:u}){const d=Boolean(o&&t),p=()=>{const h=t;return a===void 0?h:{...h,amount:Math.max(1,Math.min(a,h.amount))}},[{isDragging:y},w]=D5(()=>({type:P0,item:()=>({item:p(),source:n,type:"chest"}),canDrag:()=>d,collect:h=>({isDragging:h.isDragging()})}),[d,a,t,n]),[{isOver:x},b]=uo(()=>({accept:P0,canDrop:h=>{var m;return Boolean(s&&c&&((m=l==null?void 0:l(h,e))!=null?m:!0))},drop:h=>{c==null||c(h,e)},collect:h=>({isOver:h.isOver()&&h.canDrop()})}),[l,s,c,e]);return f(NP,{ref:h=>{if(!!h){if(s&&d){w(b(h));return}if(s){b(h);return}d&&w(h)}},$variant:r,$isOver:x,$isDragging:y,$isItem:Boolean(t),"data-trade-slot":`${n}-${e}`,onMouseDown:h=>{h.button!==2||!i||!t||(h.preventDefault(),u==null||u(e))},children:t?P(pe,{children:[f(_P,{src:lT(t),$variant:r}),P(FP,{$large:r==="buyerOffer",children:[f("span",{children:uT(t,r)}),f("span",{children:dT(t.amount)})]}),f(fT,{item:t,large:r==="buyerOffer"}),f(zP,{$large:r==="buyerOffer",$strong:r==="sellerOffer",children:cT(t,r)})]}):null})}function Yo({roleOverride:e}){var ee,$,B,G,W,R,F,V,X,k,U,M,ue,te,le;const{role:t}=vf(),n=v.exports.useMemo(()=>e!=null?e:sT(t),[e,t]),[r,o]=v.exports.useState(()=>od(n)),[i,s]=v.exports.useState(1);v.exports.useEffect(()=>{let A=!0;const H=od(n);return o(H),Oe("requestFactionTrade",{role:n},H).then(Z=>{!A||o(Oc(Z,n))}).catch(()=>{!A||o(H)}),()=>{A=!1}},[n]),ot("updateFactionTrade",A=>{o(H=>{var Z;return Oc({...H,...A},(Z=A.role)!=null?Z:n)})}),ot("factionTrade:update",A=>{o(H=>{var Z;return Oc({...H,...A},(Z=A.role)!=null?Z:n)})});const a=($=(ee=r.stock)==null?void 0:ee.items)!=null?$:[],l=r.offer.items,c=(G=(B=r.stock)==null?void 0:B.slots)!=null?G:24,u=n==="seller"?12:9,d=l.reduce((A,H)=>Math.max(A,H.slot),0),p=Math.max((W=r.offer.slots)!=null?W:u,u,d),y=(R=r.valuesMatch)!=null?R:r.price>0&&r.price===r.buyerValue,w=(V=(F=r.priceValidation)==null?void 0:F.valid)!=null?V:!0,x=Boolean(((X=r.canConfirm)!=null?X:!0)&&l.length>0&&y&&w),b=(U=(k=r.sellerConfirmed)!=null?k:r.seller.confirmed)!=null?U:!1,g=(ue=(M=r.buyerConfirmed)!=null?M:r.buyer.confirmed)!=null?ue:!1,h=n==="seller"?hT(r):void 0,m=A=>a.find(H=>H.slot===A),S=A=>l.find(H=>H.slot===A),E=(A,H)=>{if(n!=="seller")return!1;if(A.source==="offer")return A.item.slot!==H;const Z=S(H);return!Z||Z.key===A.item.key},T=(A,H)=>{if(n!=="seller"||A.source!=="offer")return!1;const Z=m(H);return!Z||Z.key===A.item.key},I=A=>{o(H=>aT(A(H)))},O=(A,H)=>{if(n!=="seller")return;if(A.source==="offer"){if(A.item.slot===H)return;I(q=>{const ae=q.offer.items.find(we=>we.slot===H),ie=q.offer.items.find(we=>we.slot===A.item.slot);if(!ie)return q;const ge=q.offer.items.map(we=>we.slot===ie.slot?{...we,slot:H}:ae&&we.slot===ae.slot?{...we,slot:ie.slot}:we);return{...q,offer:{...q.offer,items:ge}}}),ln("factionTradeMoveOfferItem",{fromSlot:A.item.slot,targetSlot:H});return}const Z=Math.max(1,Math.min(i,A.item.amount));I(q=>{var xe,st;const ae=q.offer.items.find(he=>he.slot===H);if(ae&&ae.key!==A.item.key)return q;const ie=((st=(xe=q.stock)==null?void 0:xe.items)!=null?st:[]).map(he=>he.slot!==A.item.slot?he:{...he,amount:he.amount-Z}).filter(he=>he.amount>0),ge={...A.item,slot:H,amount:Z,sourceSlot:A.item.slot},we=ae?q.offer.items.map(he=>he.slot===H?{...he,amount:he.amount+Z}:he):[...q.offer.items,ge];return{...q,stock:{...q.stock,items:ie},offer:{...q.offer,items:we}}}),ln("factionTradeOfferItem",{item:A.item.key,fromSlot:A.item.slot,targetSlot:H,amount:Z})},L=(A,H)=>{if(n!=="seller"||A.source!=="offer")return;const Z=S(A.item.slot),q=m(H);!Z||q&&q.key!==Z.key||(I(ae=>{var st,he;const ie=ae.offer.items.find(Te=>Te.slot===A.item.slot);if(!ie)return ae;const ge=(he=(st=ae.stock)==null?void 0:st.items)!=null?he:[],we=ge.find(Te=>Te.slot===H);if(we&&we.key!==ie.key)return ae;const xe=we?ge.map(Te=>Te.slot===H?{...Te,amount:Te.amount+ie.amount}:Te):[...ge,{...ie,slot:H}];return{...ae,stock:{...ae.stock,items:xe},offer:{...ae.offer,items:ae.offer.items.filter(Te=>Te.slot!==ie.slot)}}}),ln("factionTradeReturnItemToChest",{offerSlot:Z.slot,targetSlot:H,sourceSlot:Z.sourceSlot,item:Z.key,amount:Z.amount}))},_=A=>{if(n!=="seller")return;const H=S(A);!H||(I(Z=>{var we,xe,st;const q=(we=H.sourceSlot)!=null?we:H.slot,ae=(st=(xe=Z.stock)==null?void 0:xe.items)!=null?st:[],ge=ae.find(he=>he.slot===q)?ae.map(he=>he.slot===q?{...he,amount:he.amount+H.amount}:he):[...ae,{...H,slot:q}];return{...Z,stock:{...Z.stock,items:ge},offer:{...Z.offer,items:Z.offer.items.filter(he=>he.slot!==A)}}}),ln("factionTradeRemoveItem",{slot:A,item:H.key,amount:H.amount}))},re=A=>{const H=T0(A);I(Z=>({...Z,price:H,valuesMatch:H>0&&H===Z.buyerValue})),ln("factionTradeSetPrice",{price:H})},J=A=>{const H=T0(A);I(Z=>({...Z,buyerValue:H,valuesMatch:Z.price>0&&Z.price===H})),ln("factionTradeSetBuyerValue",{buyerValue:H})},se=A=>{n!=="seller"||r.hasPartnership===A||(I(H=>({...H,hasPartnership:A})),ln("factionTradeSetPartnership",{role:n,hasPartnership:A}))},j=()=>{!x||(o(A=>({...A,sellerConfirmed:n==="seller"?!0:A.sellerConfirmed,buyerConfirmed:n==="buyer"?!0:A.buyerConfirmed,seller:{...A.seller,confirmed:n==="seller"?!0:A.seller.confirmed},buyer:{...A.buyer,confirmed:n==="buyer"?!0:A.buyer.confirmed}})),ln("factionTradeConfirm",{role:n}))},Y=()=>{ln(n==="buyer"?"factionTradeReject":"factionTradeCancel",{role:n})},z=A=>A?`${Ao(A.current)} | ${Ao(A.max)}kg`:"";return f(EP,{$devBackground:pt(),"data-trade-role":n,children:P(IP,{children:[P(OP,{children:[f(AP,{children:"NEGOCIA\xC7\xC3O"}),f(DP,{children:`Vendedor: ${r.seller.name}   \u2022   ID ${r.seller.id}        |        Comprador: ${r.buyer.name}   \u2022   ID ${r.buyer.id}`})]}),f(MP,{$role:n,children:n==="seller"?P(pe,{children:[P(Sc,{$width:"20.875rem",children:[P(d0,{children:[f(Go,{children:"ESTOQUE DO BA\xDA"}),f(f0,{children:z((te=r.stock)==null?void 0:te.weight)})]}),f(Ko,{}),f(RP,{children:Ac(c).map(A=>f(Dc,{slot:A,item:m(A),source:"stock",variant:"compact",draggable:!0,droppable:!0,dragAmount:i,canDropItem:T,onDropItem:L},`stock-${A}`))}),P(h0,{children:[f(p0,{children:"i"}),f("span",{children:"Itens reservados no ba\xFA durante a negocia\xE7\xE3o."})]})]}),f(WP,{children:f(GP,{value:i>0?i:"",placeholder:"QTD",inputMode:"numeric",onChange:A=>{const H=Number(A.target.value.replace(/\D/g,""))||0;s(H)}})}),P(u0,{children:[P(Sc,{$width:"34.0625rem",children:[f(Go,{children:"NEGOCIA\xC7\xC3O"}),f(Ko,{}),f($P,{children:Ac(p).map(A=>f(Dc,{slot:A,item:S(A),source:"offer",variant:"sellerOffer",draggable:!0,droppable:!0,removable:!0,canDropItem:E,onDropItem:O,onRemove:_},`offer-${A}`))}),P(h0,{children:[f(p0,{children:"i"}),f("span",{children:"Arraste itens do estoque do ba\xFA para esta \xE1rea para oferecer ao comprador."})]})]}),P(BP,{children:[f(UP,{children:"Tem parceria?"}),P(HP,{children:[P(m0,{type:"button",$active:r.hasPartnership===!0,onClick:()=>{se(!0)},children:[f(g0,{$active:r.hasPartnership===!0}),f("span",{children:"Sim"})]}),P(m0,{type:"button",$active:r.hasPartnership===!1,onClick:()=>{se(!1)},children:[f(g0,{$active:r.hasPartnership===!1}),f("span",{children:"N\xE3o"})]})]})]}),P(y0,{$role:n,children:[f(Go,{children:"VALORES"}),f(Ko,{}),P(kc,{children:[f(Pc,{children:"Pre\xE7o estipulado"}),P(Tc,{children:[f(Ec,{children:"$"}),f(v0,{value:ur(r.price),inputMode:"numeric",onChange:A=>{re(A.target.value)}})]}),h&&P(YP,{children:[f(QP,{children:f(wP,{})}),P("span",{children:[(le=h.message)!=null?le:`Comiss\xE3o (${h.percentage}%) \xB7 Voc\xEA recebe `,P(XP,{children:["$ ",ur(h.amount)]})]})]})]}),P(kc,{children:[f(Pc,{children:"Valor do comprador"}),P(Tc,{$readonly:!0,children:[f(Ec,{$muted:!0,children:"$"}),f(KP,{$muted:!0,children:ur(r.buyerValue)})]})]}),P(w0,{$match:y,children:[f(b0,{$match:y}),f("span",{children:y?"Valores correspondem":"Valores divergentes"})]})]}),P(C0,{children:[f(Ps,{onClick:Y,children:"CANCELAR"}),f(Ps,{$primary:!0,disabled:!x,onClick:j,children:"CONFIRMAR VENDA"})]})]})]}):P(pe,{children:[P(Sc,{$width:"24.445rem",children:[P(d0,{children:[f(Go,{children:"OFERTA DO VENDEDOR"}),f(f0,{children:z(r.offer.weight)})]}),f(Ko,{}),f(LP,{children:Ac(p).map(A=>f(Dc,{slot:A,item:S(A),source:"offer",variant:"buyerOffer"},`buyer-offer-${A}`))}),f(eT,{children:P(tT,{children:[f("span",{children:"Valor estipulado pelo vendedor"}),P(Ic,{children:["$",ur(r.price)]})]})})]}),P(u0,{children:[P(y0,{$role:n,children:[f(Go,{children:"VALORES"}),f(Ko,{}),P(kc,{children:[f(Pc,{children:"Valor que deseja pagar"}),P(Tc,{$large:!0,children:[f(Ec,{$large:!0,children:"$"}),f(v0,{$large:!0,value:ur(r.buyerValue),inputMode:"numeric",onChange:A=>{J(A.target.value)}})]})]}),P(qP,{children:[P(x0,{children:[f("span",{children:"Pre\xE7o pedido"}),P(Ic,{children:["$",ur(r.price)]})]}),f(ZP,{}),P(x0,{children:[f("span",{children:"Seu valor"}),P(Ic,{children:["$",ur(r.buyerValue)]})]})]}),P(w0,{$match:y,children:[f(b0,{$match:y}),f("span",{children:y?"Valores correspondem":"Valores divergentes"})]})]}),P("div",{children:[P(C0,{children:[f(Ps,{onClick:Y,children:"RECUSAR"}),f(Ps,{$primary:!0,disabled:!x,onClick:j,children:"CONFIRMAR PAGAMENTO"})]}),f(JP,{children:"O valor ser\xE1 descontado automaticamente ao concluir a negocia\xE7\xE3o"})]})]})]})}),P(nT,{children:[P(S0,{$state:g?"confirmed":"waiting",children:[f(k0,{$state:g?"confirmed":"waiting",children:g?"\u2713":"!"}),f("span",{children:g?"Comprador confirmado":"Aguardando comprador"})]}),f(rT,{}),P(S0,{$state:b?"confirmed":"waiting",children:[f(k0,{$state:b?"confirmed":"waiting",children:b?"\u2713":"!"}),f("span",{children:b?"Vendedor confirmado":n==="seller"?"Aguardando sua confirma\xE7\xE3o":"Aguardando vendedor"})]})]})]})})}const pT=C.div`
  position: fixed;
  inset: 0;
  z-index: 20;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(5, 7, 10, 0.66);
  color: #ffffff;
`,mT=C.section`
  width: 47.6875rem;
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
  padding: 2rem 2rem 1.75rem;
  border-radius: 1.125rem;
  border: 1px solid rgba(255, 255, 255, 0.1);
  background: #0c1015;
`,gT=C.header`
  display: flex;
  align-items: center;
  gap: 1rem;
  width: 100%;
`,yT=C.div`
  display: flex;
  align-items: center;
  gap: 1rem;
  flex: 1;
  min-width: 0;
`,vT=C.div`
  width: 3.25rem;
  height: 3.25rem;
  flex: none;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 0.8125rem;
  border: 1px solid ${({theme:e})=>e.colors["main-opacity"][400]};
  background: ${({theme:e})=>e.colors["main-opacity"][100]};
  color: ${({theme:e})=>e.colors.main[500]};

  svg {
    width: 1.75rem;
    height: 1.75rem;
  }
`,xT=C.div`
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 0.1875rem;
`,wT=C.div`
  position: relative;
  flex: none;
  display: flex;
  align-items: center;
  gap: 0.5rem;
`,bT=C.div`
  position: relative;
  flex: none;
`,CT=C.h1`
  color: rgba(255, 255, 255, 0.97);
  font-size: 1.25rem;
  font-weight: 800;
  line-height: normal;
  letter-spacing: -0.0125rem;
  text-transform: uppercase;
`,ST=C.p`
  color: rgba(255, 255, 255, 0.55);
  font-size: 0.875rem;
  font-weight: 400;
  line-height: normal;
`,kT=C.button`
  width: 2.75rem;
  height: 2.75rem;
  flex: none;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 1px solid
    ${({$open:e,theme:t})=>e?t.colors["main-opacity"][500]:"rgba(255, 255, 255, 0.1)"};
  border-radius: 0.5rem;
  background: ${({$open:e,theme:t})=>e?t.colors["main-opacity"][100]:"#0f141a"};
  color: ${({$open:e,theme:t})=>e?t.colors.main[500]:"rgba(255, 255, 255, 0.95)"};
  transition:
    background 0.15s ease,
    border-color 0.15s ease,
    color 0.15s ease;

  svg {
    width: 1.125rem;
    height: 1.125rem;
  }

  &:hover {
    background: ${({$open:e,theme:t})=>e?t.colors["main-opacity"][200]:"#151c23"};
    border-color: ${({$open:e,theme:t})=>e?t.colors["main-opacity"][500]:"rgba(255, 255, 255, 0.18)"};
  }
`,PT=C.div`
  position: absolute;
  z-index: 8;
  top: calc(100% + 0.625rem);
  right: 0;
  width: 22rem;
  max-height: 18rem;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  gap: 0.375rem;
  padding: 0.625rem;
  border-radius: 0.625rem;
  border: 1px solid rgba(255, 255, 255, 0.1);
  background: #0a0d11;
  box-shadow: 0 1rem 2rem rgba(0, 0, 0, 0.55);

  &::-webkit-scrollbar {
    display: none;
  }
`,TT=C.strong`
  padding: 0.25rem 0.375rem 0.5rem;
  color: rgba(255, 255, 255, 0.72);
  font-size: 0.75rem;
  font-weight: 700;
  line-height: normal;
  text-transform: uppercase;
`,ET=C.div`
  width: 100%;
  min-height: 3.25rem;
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.625rem 0.75rem;
  border-radius: 0.5rem;
  background: rgba(255, 255, 255, 0.035);
`,IT=C.div`
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 0.1875rem;
`,OT=C.strong`
  min-width: 0;
  overflow: hidden;
  color: rgba(255, 255, 255, 0.9);
  font-size: 0.875rem;
  font-weight: 700;
  line-height: normal;
  text-overflow: ellipsis;
  white-space: nowrap;
`,AT=C.span`
  min-width: 0;
  overflow: hidden;
  color: rgba(255, 255, 255, 0.42);
  font-size: 0.75rem;
  font-weight: 500;
  line-height: normal;
  text-overflow: ellipsis;
  white-space: nowrap;
`,E0=C.span`
  display: flex;
  align-items: center;
  min-height: 3rem;
  padding: 0 0.75rem;
  color: rgba(255, 255, 255, 0.4);
  font-size: 0.8125rem;
  font-weight: 500;
`,DT=C.button`
  width: 2.75rem;
  height: 2.75rem;
  flex: none;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 0.5rem;
  background: #0f141a;
  color: rgba(255, 255, 255, 0.95);
  transition:
    background 0.15s ease,
    border-color 0.15s ease;

  svg {
    width: 1.125rem;
    height: 1.125rem;
  }

  &:hover {
    background: #151c23;
    border-color: rgba(255, 255, 255, 0.18);
  }
`,MT=C.section`
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 0.875rem;
  padding: 1.25rem;
  border-radius: 0.875rem;
  border: 1px solid rgba(255, 255, 255, 0.05);
  background: #0a0d11;
`,RT=C.span`
  color: rgba(255, 255, 255, 0.4);
  font-size: 0.6875rem;
  font-weight: 700;
  line-height: normal;
  letter-spacing: 0.055rem;
  text-transform: uppercase;
`,$T=C.div`
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 0.625rem;
  width: 100%;
`,I0=C.button`
  height: 2.75rem;
  padding: 0.75rem 0.875rem;
  border-radius: 0.5625rem;
  border: 1px solid rgba(255, 255, 255, 0.06);
  background: #0f141a;
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.875rem;
  font-weight: 600;
  transition:
    border-color 0.15s ease,
    background 0.15s ease,
    color 0.15s ease;

  ${({$active:e,theme:t})=>e&&de`
      border-color: ${t.colors["main-opacity"][500]};
      background: ${t.colors["main-opacity"][100]};
      color: ${t.colors.main[500]};
    `}
`,LT=C.div`
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
`,NT=C.div`
  position: relative;
  width: 100%;
`,_T=C.span`
  color: rgba(255, 255, 255, 0.5);
  font-size: 0.75rem;
  font-weight: 500;
  line-height: normal;
`,FT=C.div`
  width: 100%;
  height: 3rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0 0.75rem 0 0.875rem;
  border-radius: 0.5rem;
  border: 1px solid
    ${({$open:e,theme:t})=>e?t.colors["main-opacity"][500]:"rgba(255, 255, 255, 0.1)"};
  background: #0a0d11;
  color: rgba(255, 255, 255, 0.62);
  font-size: 0.9375rem;
  font-weight: 600;
  text-align: left;
  cursor: text;
  transition: border-color 0.15s ease;

  svg {
    width: 0.625rem;
    height: 0.625rem;
    flex: none;
    color: rgba(255, 255, 255, 0.4);
    transform: rotate(${({$open:e})=>e?"180deg":"0deg"});
    transition: transform 0.15s ease;
  }
`,zT=C.input`
  flex: 1;
  height: 100%;
  min-width: 0;
  border: 0;
  outline: 0;
  padding: 0;
  background: transparent;
  color: rgba(255, 255, 255, 0.72);
  font-size: 0.9375rem;
  font-weight: 600;
  font-family: inherit;
  text-align: left;
  overflow: hidden;
  text-overflow: ellipsis;

  &::placeholder {
    color: rgba(255, 255, 255, 0.36);
  }

  &::-webkit-search-cancel-button {
    display: none;
  }
`,VT=C.div`
  position: absolute;
  z-index: 5;
  top: calc(100% + 0.375rem);
  left: 0;
  right: 0;
  max-height: 15rem;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  gap: 0.125rem;
  padding: 0.375rem;
  border-radius: 0.5rem;
  border: 1px solid rgba(255, 255, 255, 0.1);
  background: #0a0d11;
  box-shadow: 0 1rem 2rem rgba(0, 0, 0, 0.55);

  &::-webkit-scrollbar {
    display: none;
  }
`,jT=C.button`
  width: 100%;
  height: 2.75rem;
  flex: none;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 0.5rem;
  padding: 0 0.875rem;
  border: 0;
  border-radius: 0.375rem;
  background: transparent;
  color: rgba(255, 255, 255, 0.62);
  font-size: 0.9375rem;
  font-weight: 600;
  text-align: left;
  transition:
    background 0.15s ease,
    color 0.15s ease;

  span {
    min-width: 0;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  svg {
    width: 0.75rem;
    height: 0.75rem;
    flex: none;
  }

  &:hover {
    background: rgba(255, 255, 255, 0.04);
    color: rgba(255, 255, 255, 0.85);
  }

  ${({$active:e,theme:t})=>e&&de`
      background: ${t.colors["main-opacity"][100]};
      color: ${t.colors.main[500]};

      &:hover {
        background: ${t.colors["main-opacity"][200]};
        color: ${t.colors.main[500]};
      }
    `}
`,BT=C.span`
  display: flex;
  align-items: center;
  height: 2.75rem;
  padding: 0 0.875rem;
  color: rgba(255, 255, 255, 0.35);
  font-size: 0.8125rem;
  font-weight: 400;
`,UT=C.div`
  width: 100%;
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1.125rem 1.25rem;
  border-radius: 0.875rem;
  border: 1px solid rgba(255, 255, 255, 0.06);
  background: #0a0d11;
`,HT=C.div`
  width: 2.75rem;
  height: 2.75rem;
  flex: none;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 0.6875rem;
  border: 1px solid ${({theme:e})=>e.colors["main-opacity"][300]};
  background: ${({theme:e})=>e.colors["main-opacity"][100]};
  color: ${({theme:e})=>e.colors.main[500]};

  svg {
    width: 1.375rem;
    height: 1.375rem;
  }
`,WT=C.div`
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 0.1875rem;
`,GT=C.strong`
  color: rgba(255, 255, 255, 0.96);
  font-size: 0.9375rem;
  font-weight: 600;
  line-height: normal;
`,KT=C.span`
  color: rgba(255, 255, 255, 0.5);
  font-size: 0.78125rem;
  font-weight: 400;
  line-height: 1.35;
`,YT=C.div`
  flex: none;
  display: grid;
  grid-template-columns: repeat(5, 3.5rem);
  gap: 0.5rem;
`,QT=C.button`
  height: 2.75rem;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: 0.5rem;
  font-size: 0.875rem;
  font-weight: 700;
  line-height: normal;
  transition:
    filter 0.15s ease,
    background 0.15s ease,
    border-color 0.15s ease,
    color 0.15s ease;

  ${({$active:e,theme:t})=>e?de`
          border: 1px solid ${t.colors.main[500]};
          background: ${t.colors.main[500]};
          color: #0a0d11;
        `:de`
          border: 1px solid rgba(255, 255, 255, 0.1);
          background: #0f141a;
          color: rgba(255, 255, 255, 0.55);
        `}

  &:hover {
    filter: brightness(1.08);
    border-color: ${({$active:e,theme:t})=>e?t.colors.main[500]:"rgba(255, 255, 255, 0.18)"};
  }
`,O0=C.div`
  width: 100%;
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1.125rem 1.25rem;
  border-radius: 0.875rem;
  transition:
    background 0.15s ease,
    border-color 0.15s ease;

  ${({$on:e,theme:t})=>e?de`
          border: 1px solid ${t.colors["main-opacity"][300]};
          background: ${t.colors["main-opacity"][100]};
        `:de`
          border: 1px solid rgba(255, 255, 255, 0.06);
          background: #0a0d11;
        `}
`,A0=C.button`
  width: 2.5rem;
  height: 1.4375rem;
  flex: none;
  display: flex;
  align-items: center;
  border-radius: 999px;
  transition:
    background 0.15s ease,
    border-color 0.15s ease;

  ${({$checked:e,theme:t})=>e?de`
          border: 1px solid transparent;
          background: ${t.colors.main[500]};
        `:de`
          border: 1px solid rgba(255, 255, 255, 0.1);
          background: #151c23;
        `}

  &::after {
    content: "";
    width: 1.0625rem;
    height: 1.0625rem;
    border-radius: 50%;
    background: ${({$checked:e})=>e?"#ffffff":"rgba(255, 255, 255, 0.45)"};
    transform: translateX(
      ${({$checked:e})=>e?"1.3125rem":"0.125rem"}
    );
    transition:
      transform 0.15s ease,
      background 0.15s ease;
  }
`,XT=C.button`
  width: 2.25rem;
  height: 1.25rem;
  flex: none;
  display: flex;
  align-items: center;
  border-radius: 999px;
  border: 1px solid
    ${({$checked:e,theme:t})=>e?"transparent":"rgba(255, 255, 255, 0.1)"};
  background: ${({$checked:e,theme:t})=>e?t.colors.main[500]:"#151c23"};
  transition:
    background 0.15s ease,
    border-color 0.15s ease,
    filter 0.15s ease;

  &::after {
    content: "";
    width: 0.875rem;
    height: 0.875rem;
    border-radius: 50%;
    background: ${({$checked:e})=>e?"#ffffff":"rgba(255, 255, 255, 0.45)"};
    transform: translateX(${({$checked:e})=>e?"1.0625rem":"0.125rem"});
    transition:
      transform 0.15s ease,
      background 0.15s ease;
  }

  &:hover {
    filter: brightness(1.08);
  }
`,D0=C.div`
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 0.1875rem;
`,M0=C.strong`
  color: rgba(255, 255, 255, 0.96);
  font-size: 0.9375rem;
  font-weight: 600;
  line-height: normal;
`;C.span`
  color: rgba(255, 255, 255, 0.6);
  font-size: 0.78125rem;
  font-weight: 400;
  line-height: 1.35;
`;C.span`
  flex: none;
  padding: 0.3125rem 0.625rem;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.06);
  color: ${({$active:e})=>e?"rgba(255, 255, 255, 0.55)":"rgba(255, 255, 255, 0.4)"};
  font-size: 0.6875rem;
  font-weight: 600;
  line-height: normal;
  white-space: nowrap;
`;const qT=C.footer`
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 0.75rem;
`,ZT=C.span`
  flex: 1;
  min-width: 0;
  color: rgba(255, 255, 255, 0.35);
  font-size: 0.75rem;
  font-weight: 400;
  line-height: normal;
`,R0=C.button`
  height: 3rem;
  flex: none;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  padding: 0 1.25rem;
  border-radius: 0.5rem;
  font-size: 0.9375rem;
  font-weight: 600;
  letter-spacing: -0.009375rem;
  transition:
    filter 0.15s ease,
    background 0.15s ease,
    border-color 0.15s ease;

  ${({$primary:e,theme:t})=>e?de`
          border: 1px solid ${t.colors.main[500]};
          background: ${t.colors.main[500]};
          color: #ffffff;
        `:de`
          border: 1px solid rgba(255, 255, 255, 0.1);
          background: #0f141a;
          color: rgba(255, 255, 255, 0.95);
        `}

  &:hover {
    filter: brightness(1.08);
  }
`,JT=e=>{const t=(e!=null?e:"").toLowerCase();return t.includes("cargo")||t.includes("role")?"role":"member"},eE=(e,t)=>({member:[{id:152,name:"Jo\xE3o Silva",label:e},{id:287,name:"Marina Alves",label:e},{id:304,name:"Carlos Dias",label:e}],role:[{id:"lider",name:"L\xEDder",label:t},{id:"gerente",name:"Gerente",label:t},{id:"membro",name:e,label:t}]}),$0=(e,t)=>[{id:152,name:"Jo\xE3o Silva",label:e,mode:"member"},{id:304,name:"Carlos Dias",label:e,mode:"member"},{id:"gerente",name:"Gerente",label:t,mode:"role"}],tE=[10,15,20,25,30],id=(e,t,n)=>({mode:e,target:e==="member"?{id:152,name:"Jo\xE3o Silva",label:t}:{id:"gerente",name:"Gerente",label:n},options:eE(t,n)[e],saleCommissionPercentage:15,authorizedToWithdraw:!1,authorizedToConfigureChest:!1,limitsActive:!0,limits:[]}),L0=(e,t,n,r)=>{var i,s,a;const o=id(t,n,r);return e?{...o,...e,mode:(i=e.mode)!=null?i:t,target:{...o.target,...e.target},options:(s=e.options)!=null?s:o.options,limits:(a=e.limits)!=null?a:o.limits}:o},Mc=(e,t)=>t==="member"?`${e.name}  \xB7  ID ${e.id}`:e.name,N0=e=>{var t;return e?Array.isArray(e)?e:(t=e.items)!=null?t:[]:[]},Gs=e=>{var t;return(t=e.mode)!=null?t:typeof e.id=="number"?"member":"role"},nE=(e,t,n)=>{const r=Gs(e),o=e.label==="Membro"?t:e.label==="Cargo do membro"?n:e.label;return r==="member"?`${o!=null?o:t} - ID ${e.id}`:o!=null?o:n},_0=e=>e.normalize("NFD").replace(/[\u0300-\u036f]/g,"").toLowerCase().trim(),cn=(e,t)=>{Oe(e,t)};function Qo({modeOverride:e}){var V,X;const t=cl(),{t:n}=Zt(),{mode:r}=vf(),o=n("chestPermission.member"),i=n("chestPermission.memberRole"),s=v.exports.useMemo(()=>e!=null?e:JT(r),[e,r]),[a,l]=v.exports.useState(()=>id(s,o,i)),[c,u]=v.exports.useState(!1),[d,p]=v.exports.useState(""),[y,w]=v.exports.useState(!1),[x,b]=v.exports.useState(!1),[g,h]=v.exports.useState([]),m=v.exports.useRef(null),S=v.exports.useRef(null),E=v.exports.useRef(null);v.exports.useEffect(()=>{let k=!0;const U=id(s,o,i);return l(M=>({...U,showSaleCommission:M.showSaleCommission})),u(!1),p(""),w(!1),Oe("requestChestPermissionConfig",{mode:s},U).then(M=>{!k||l(ue=>{var te;return L0({...M,showSaleCommission:(te=M==null?void 0:M.showSaleCommission)!=null?te:ue.showSaleCommission},s,o,i)})}).catch(()=>{!k||l(M=>({...U,showSaleCommission:M.showSaleCommission}))}),()=>{k=!1}},[o,s,i]),v.exports.useEffect(()=>{if(!c)return;const k=M=>{var ue,te;(te=(ue=m.current)==null?void 0:ue.contains(M.target))!=null&&te||(u(!1),p(""))},U=M=>{M.code==="Escape"&&(M.stopPropagation(),u(!1),p(""))};return window.addEventListener("mousedown",k),window.addEventListener("keydown",U,!0),()=>{window.removeEventListener("mousedown",k),window.removeEventListener("keydown",U,!0)}},[c]),v.exports.useEffect(()=>{if(!y)return;const k=M=>{var ue,te;(te=(ue=E.current)==null?void 0:ue.contains(M.target))!=null&&te||w(!1)},U=M=>{M.code==="Escape"&&(M.stopPropagation(),w(!1))};return window.addEventListener("mousedown",k),window.addEventListener("keydown",U,!0),()=>{window.removeEventListener("mousedown",k),window.removeEventListener("keydown",U,!0)}},[y]),ot("updateChestPermissionConfig",k=>{l(U=>{var M;return L0({...U,...k},(M=k.mode)!=null?M:s,o,i)})}),ot("updateChestPermissionAuthorizedList",k=>{h(N0(k)),b(!1)}),(V=a.limitsActive)!=null||a.authorizedToWithdraw;const T=n(s==="member"?"chestPermission.configureBy":"chestPermission.whoCanWithdraw"),I=n(s==="member"?"chestPermission.configureMember":"chestPermission.configureRole"),O=Mc(a.target,s),L=(X=a.options)!=null?X:[],_=v.exports.useMemo(()=>{const k=_0(d);return k?L.filter(U=>{const M=[Mc(U,s),U.label,U.role,String(U.id)].filter(Boolean).join(" ");return _0(M).includes(k)}):L},[s,L,d]),re=k=>{k!==s&&(cn("chestPermissionSetMode",{mode:k}),t(`/chest-permission/${k}`))},J=()=>{const k=!a.authorizedToWithdraw;l(U=>({...U,authorizedToWithdraw:k,limitsActive:!k})),cn("chestPermissionSetWithdrawAuthorization",{mode:s,targetId:a.target.id,authorizedToWithdraw:k})},se=()=>{const k=!a.authorizedToConfigureChest;l(U=>({...U,authorizedToConfigureChest:k})),cn("chestPermissionSetConfigureAuthorization",{mode:s,targetId:a.target.id,authorizedToConfigureChest:k})},j=k=>{const U=a.saleCommissionPercentage===k?null:k;l(M=>({...M,saleCommissionPercentage:U})),cn("chestPermissionSetSaleCommission",{mode:s,targetId:a.target.id,saleCommissionPercentage:U})},Y=()=>{b(!0),Oe("requestChestPermissionAuthorizedList",{mode:s,targetId:a.target.id},{items:$0(o,i)}).then(k=>{h(N0(k))}).catch(()=>{h($0(o,i))}).finally(()=>{b(!1)})},z=()=>{const k=!y;w(k),k&&Y()},ee=k=>{const U=Gs(k);h(M=>M.filter(ue=>ue.id!==k.id||Gs(ue)!==U)),k.id===a.target.id&&U===s&&l(M=>({...M,authorizedToWithdraw:!1,authorizedToConfigureChest:!1,limitsActive:!0})),cn("chestPermissionRemoveAuthorizedTarget",{mode:U,targetId:k.id,target:k})},$=()=>{c||(p(""),u(!0),cn("chestPermissionSelectTarget",{mode:s,targetId:a.target.id}))},B=k=>{p(k),c||u(!0)},G=k=>{u(!1),p(""),k.id!==a.target.id&&(l(U=>({...U,target:k})),cn("chestPermissionSetTarget",{mode:s,targetId:k.id,target:k}))},W=k=>{if(k.code==="Escape"){k.stopPropagation(),u(!1),p("");return}if(k.code!=="Enter")return;const U=_[0];!U||(k.preventDefault(),G(U))},R=()=>{cn("chestPermissionSave",{mode:s,targetId:a.target.id,config:a})},F=()=>{cn("chestPermissionClose",{mode:s,targetId:a.target.id})};return f(pT,{"data-chest-permission-mode":s,children:P(mT,{children:[P(gT,{children:[P(yT,{children:[f(vT,{children:f(bP,{})}),P(xT,{children:[f(CT,{children:n("chestPermission.title")}),f(ST,{children:n("chestPermission.subtitle")})]})]}),P(wT,{children:[P(bT,{ref:E,children:[f(kT,{type:"button",$open:y,onClick:z,"aria-label":n("chestPermission.viewPermissions"),"aria-haspopup":"listbox","aria-expanded":y,"data-chest-authorized-trigger":!0,children:f(fo,{})}),y&&P(PT,{role:"listbox",children:[f(TT,{children:n("chestPermission.activePermissions")}),x?f(E0,{children:n("chestPermission.loadingPermissions")}):g.length===0?f(E0,{children:n("chestPermission.noActivePermission")}):g.map(k=>P(ET,{children:[P(IT,{children:[f(OT,{children:k.name}),f(AT,{children:nE(k,o,i)})]}),f(XT,{type:"button",$checked:!0,onClick:()=>{ee(k)},"aria-label":n("chestPermission.removePermission",k.name),"data-chest-authorized-remove":!0})]},`${Gs(k)}-${String(k.id)}`))]})]}),f(DT,{onClick:F,"aria-label":n("chestPermission.close"),children:f(Ws,{})})]})]}),P(MT,{children:[f(RT,{children:T}),P($T,{children:[f(I0,{type:"button",$active:s==="role",onClick:()=>{re("role")},children:i}),f(I0,{type:"button",$active:s==="member",onClick:()=>{re("member")},children:n("chestPermission.memberId")})]}),P(LT,{children:[f(_T,{children:I}),P(NT,{ref:m,children:[P(FT,{$open:c,onClick:()=>{var k;return(k=S.current)==null?void 0:k.focus()},children:[f(zT,{ref:S,value:c?d:O,placeholder:O,onFocus:$,onInput:k=>{B(k.currentTarget.value)},onChange:k=>{B(k.currentTarget.value)},onKeyDown:W,role:"combobox","aria-haspopup":"listbox","aria-expanded":c,"aria-controls":"chest-permission-target-options"}),f(B5,{})]}),c&&f(VT,{id:"chest-permission-target-options",role:"listbox",children:_.length===0?f(BT,{children:L.length===0?n("chestPermission.noOptionAvailable"):n("chestPermission.noOptionFound")}):_.map(k=>P(jT,{type:"button",role:"option","aria-selected":k.id===a.target.id,$active:k.id===a.target.id,onClick:()=>{G(k)},children:[f("span",{children:Mc(k,s)}),k.id===a.target.id&&f(vP,{})]},String(k.id)))})]})]})]}),a.showSaleCommission!==!1&&P(UT,{children:[f(HT,{children:f(CP,{})}),P(WT,{children:[f(GT,{children:n("chestPermission.saleCommission")}),f(KT,{children:n("chestPermission.saleCommissionDescription")})]}),f(YT,{"aria-label":n("chestPermission.saleCommission"),children:tE.map(k=>P(QT,{type:"button",$active:a.saleCommissionPercentage===k,onClick:()=>{j(k)},children:[k,"%"]},k))})]}),P(O0,{$on:a.authorizedToWithdraw,children:[f(A0,{type:"button",$checked:a.authorizedToWithdraw,onClick:J,"aria-label":n("chestPermission.authorizeWithdraw")}),f(D0,{children:f(M0,{children:n("chestPermission.authorizedToWithdraw")})})]}),P(O0,{$on:a.authorizedToConfigureChest,children:[f(A0,{type:"button",$checked:a.authorizedToConfigureChest,onClick:se,"aria-label":n("chestPermission.authorizeConfigureChest")}),f(D0,{children:f(M0,{children:n("chestPermission.authorizedToConfigureChest")})})]}),P(qT,{children:[f(ZT,{children:n("chestPermission.immediateChangesHint")}),f(R0,{type:"button",onClick:F,children:n("chestPermission.cancel")}),f(R0,{type:"button",$primary:!0,onClick:R,children:n("chestPermission.saveChanges")})]})]})})}const es=de`
  &::-webkit-scrollbar {
    width: 0.1875rem;
  }

  &::-webkit-scrollbar-track {
    background: rgba(255, 255, 255, 0.06);
    border-radius: 999px;
  }

  &::-webkit-scrollbar-thumb {
    background: ${({theme:e})=>e.colors["main-opacity"][500]};
    border-radius: 999px;
  }
`,rE=C.div`
  position: fixed;
  inset: 0;
  z-index: 2147483647;
  display: flex;
  align-items: center;
  justify-content: flex-start;
  padding: 2rem;
  background: rgba(5, 7, 10, 0.72);
  color: #ffffff;
`,oE=C.section`
  position: relative;
  z-index: 1;
  width: ${({$view:e})=>e==="home"||e==="help"?"30rem":"36.25rem"};
  height: ${({$view:e})=>e==="role-detail"?"min(47.625rem, calc(100vh - 4rem))":"auto"};
  max-height: calc(100vh - 4rem);
  display: flex;
  flex-direction: column;
  gap: ${({$view:e})=>e==="help"?"1.25rem":"1.375rem"};
  padding: 1.75rem 1.75rem 1.5rem;
  border-radius: 1.125rem;
  border: 1px solid rgba(255, 255, 255, 0.1);
  background: #0c1015;
  box-shadow: 0 1.125rem 2.75rem rgba(0, 0, 0, 0.6);
  overflow: hidden;
`,iE=C.header`
  width: 100%;
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 1rem;
`,sE=C.div`
  flex: 1;
  min-width: 0;
  display: flex;
  align-items: center;
`,aE=C.div`
  flex: none;
  display: flex;
  align-items: center;
  gap: 0.75rem;
`;C.div`
  width: 3.25rem;
  height: 3.25rem;
  flex: none;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 0.8125rem;
  border: 1px solid ${({theme:e})=>e.colors["main-opacity"][400]};
  background: ${({theme:e})=>e.colors["main-opacity"][100]};
  color: ${({theme:e})=>e.colors.main[500]};

  svg {
    width: 1.75rem;
    height: 1.75rem;
  }
`;const lE=C.div`
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 0.3125rem;
`,cE=C.h1`
  color: rgba(255, 255, 255, 0.97);
  font-size: 1.25rem;
  font-weight: 800;
  line-height: normal;
  letter-spacing: -0.01875rem;
`,uE=C.p`
  color: rgba(255, 255, 255, 0.5);
  font-size: 0.875rem;
  font-weight: 400;
  line-height: normal;
`,qf=de`
  width: 2.75rem;
  height: 2.75rem;
  flex: none;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 0.5rem;
  background: #0f141a;
  color: rgba(255, 255, 255, 0.95);
  transition:
    background 0.15s ease,
    border-color 0.15s ease;

  svg {
    width: 1.125rem;
    height: 1.125rem;
  }

  &:hover {
    background: #151c23;
    border-color: rgba(255, 255, 255, 0.18);
  }
`,dE=C.button`
  ${qf}
`,Rc=C.button`
  ${qf}
`,fE=C.button`
  ${qf}

  svg {
    width: 1.25rem;
    height: 1.25rem;
  }
`,hE=C.div`
  display: inline-flex;
  align-items: center;
  gap: 0.625rem;
  padding: 0.6875rem 1.125rem 0.6875rem 0.875rem;
  border-radius: 0.625rem;
  border: 1px solid rgba(255, 255, 255, 0.09);
  background: #0f141a;
  color: rgba(255, 255, 255, 0.92);
  font-size: 0.875rem;
  font-weight: 600;
  line-height: normal;
  white-space: nowrap;

  svg {
    width: 1.1875rem;
    height: 1.1875rem;
    color: ${({theme:e})=>e.colors.main[500]};
  }
`;C.section`
  width: 100%;
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1.25rem;
  border-radius: 0.875rem;
  border: 1px solid
    ${({$ready:e,theme:t})=>e?t.colors["main-opacity"][300]:"rgba(255, 255, 255, 0.07)"};
  background: ${({$ready:e,theme:t})=>e?t.colors["main-opacity"][100]:"#0f141a"};
`;C.div`
  width: 2.625rem;
  height: 2.625rem;
  flex: none;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 0.625rem;
  border: 1px solid
    ${({$ready:e,theme:t})=>e?t.colors["main-opacity"][400]:"rgba(255, 255, 255, 0.07)"};
  background: ${({$ready:e,theme:t})=>e?t.colors["main-opacity"][200]:"rgba(255, 255, 255, 0.05)"};
  color: ${({$ready:e,theme:t})=>e?t.colors.main[500]:"rgba(255, 255, 255, 0.45)"};

  svg {
    width: 1.375rem;
    height: 1.375rem;
  }
`;C.div`
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
`;C.strong`
  color: rgba(255, 255, 255, 0.94);
  font-size: 0.9375rem;
  font-weight: 600;
  line-height: normal;
`;C.span`
  color: rgba(255, 255, 255, 0.55);
  font-size: 0.78125rem;
  font-weight: 400;
  line-height: 1.35;
`;C.section`
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 0.875rem;
  padding: 1.25rem;
  border-radius: 0.875rem;
  border: 1px solid rgba(255, 255, 255, 0.05);
  background: #0a0d11;
`;C.span`
  color: rgba(255, 255, 255, 0.4);
  font-size: 0.6875rem;
  font-weight: 700;
  line-height: normal;
  letter-spacing: 0.055rem;
  text-transform: uppercase;
`;const pE=C.div`
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 0.625rem;
`,Dn=C.button`
  position: relative;
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: flex-start;
  gap: 0.875rem;
  padding: 1rem 1.125rem 1rem 1.125rem;
  border-radius: 0.75rem;
  text-align: left;
  line-height: normal;
  overflow: hidden;
  transition:
    filter 0.15s ease,
    background 0.15s ease,
    border-color 0.15s ease,
    color 0.15s ease,
    opacity 0.15s ease;

  &::before {
    content: "";
    position: absolute;
    top: 0;
    bottom: 0;
    left: 0;
    width: 0.1875rem;
    background: transparent;
  }

  ${({$primary:e,$danger:t,theme:n})=>e?de`
        border: 1px solid ${n.colors["main-opacity"][500]};
        background: ${n.colors["main-opacity"][100]};
        color: ${n.colors.main[500]};

        &::before {
          background: ${n.colors.main[500]};
        }
      `:t?de`
        border: 1px solid rgba(255, 255, 255, 0.07);
        background: #0f141a;
        color: #ff4d52;
      `:de`
      border: 1px solid rgba(255, 255, 255, 0.07);
      background: #0f141a;
      color: rgba(255, 255, 255, 0.94);
    `}

  &:hover:not(:disabled) {
    filter: brightness(1.08);
  }

  &:disabled {
    cursor: not-allowed;
    border-color: rgba(255, 255, 255, 0.04);
    background: #0a0d11;
    color: rgba(255, 255, 255, 0.35);
  }
`,Br=C.span`
  width: 2.625rem;
  height: 2.625rem;
  flex: none;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 0.625rem;
  border: 1px solid rgba(255, 255, 255, 0.07);
  background: rgba(255, 255, 255, 0.05);

  svg {
    width: 1.375rem;
    height: 1.375rem;
  }

  ${Dn}:disabled & {
    opacity: 0.5;
  }
`,Ur=C.span`
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
`,Hr=C.strong`
  min-width: 0;
  color: currentColor;
  font-size: 0.9375rem;
  font-weight: 600;
  line-height: normal;
`,Wr=C.span`
  min-width: 0;
  color: rgba(255, 255, 255, 0.55);
  font-size: 0.78125rem;
  font-weight: 400;
  line-height: 1.35;

  ${Dn}:disabled & {
    color: rgba(255, 255, 255, 0.25);
  }
`,mE=C.div`
  width: calc(100% + 0.625rem);
  min-height: 0;
  display: flex;
  flex-direction: column;
  gap: 0.625rem;
  padding-right: 0.625rem;
  margin-right: -0.625rem;
  overflow-y: auto;
  overflow-x: hidden;

  ${es}
`,gE=C.div`
  width: 100%;
  flex: none;
  display: flex;
  align-items: flex-start;
  gap: 0.875rem;
  padding: 1rem 1.125rem;
  border-radius: 0.75rem;
  border: 1px solid rgba(255, 255, 255, 0.04);
  background: #0a0d11;
`,yE=C.span`
  width: 1.375rem;
  height: 1.375rem;
  flex: none;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  color: ${({theme:e})=>e.colors.main[500]};

  svg {
    width: 1.375rem;
    height: 1.375rem;
  }
`,vE=C.div`
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
`,xE=C.strong`
  color: rgba(255, 255, 255, 0.88);
  font-size: 0.9375rem;
  font-weight: 600;
  line-height: normal;
`,wE=C.span`
  color: rgba(255, 255, 255, 0.45);
  font-size: 0.78125rem;
  font-weight: 400;
  line-height: 1.35;
`,bE=C.div`
  width: 100%;
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.75rem;
  border-radius: 0.75rem;
  border: 1px solid ${({theme:e})=>e.colors["main-opacity"][300]};
  background: ${({theme:e})=>e.colors["main-opacity"][100]};
`,CE=C.span`
  width: 1.375rem;
  height: 1.375rem;
  flex: none;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  color: ${({theme:e})=>e.colors.main[500]};

  svg {
    width: 1.375rem;
    height: 1.375rem;
  }
`,SE=C.div`
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 0.125rem;
`,kE=C.strong`
  color: ${({theme:e})=>e.colors.main[500]};
  font-size: 0.875rem;
  font-weight: 700;
  letter-spacing: 0.07rem;
  line-height: normal;
`,PE=C.span`
  color: rgba(255, 255, 255, 0.62);
  font-size: 0.7125rem;
  font-weight: 400;
  line-height: 1.35;
`,TE=C.div`
  width: 100%;
  display: flex;
  align-items: center;
  gap: 0.75rem;
`,EE=C.label`
  height: 2.5rem;
  flex: 1;
  min-width: 0;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0 0.875rem;
  border-radius: 0.5rem;
  border: 1px solid rgba(255, 255, 255, 0.1);
  background: #0a0d11;
  color: rgba(255, 255, 255, 0.4);

  svg {
    width: 0.875rem;
    height: 0.875rem;
    flex: none;
  }
`,IE=C.input`
  width: 100%;
  min-width: 0;
  height: 100%;
  border: 0;
  outline: 0;
  background: transparent;
  color: rgba(255, 255, 255, 0.92);
  font-size: 0.875rem;
  font-weight: 400;
  line-height: normal;

  &::placeholder {
    color: rgba(255, 255, 255, 0.4);
  }
`,OE=C.span`
  flex: none;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0.6875rem 1rem;
  border-radius: 0.625rem;
  border: 1px solid rgba(255, 255, 255, 0.07);
  background: #0f141a;
  color: rgba(255, 255, 255, 0.6);
  font-size: 0.78125rem;
  font-weight: 500;
  line-height: normal;
  white-space: nowrap;
`,AE=C.section`
  width: calc(100% + 0.625rem);
  max-height: 26rem;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  padding-right: 0.625rem;
  margin-right: -0.625rem;
  overflow-y: auto;
  overflow-x: hidden;

  ${es}
`,DE=C.button`
  position: relative;
  width: 100%;
  flex: none;
  display: grid;
  grid-template-columns: 2.25rem minmax(0, 1fr) auto auto auto;
  align-items: center;
  gap: 0.75rem;
  padding: 0.8125rem 1rem 0.8125rem 1rem;
  border-radius: 0.75rem;
  text-align: left;
  overflow: hidden;
  transition:
    background 0.15s ease,
    border-color 0.15s ease,
    filter 0.15s ease;

  &::before {
    content: "";
    position: absolute;
    top: 0;
    bottom: 0;
    left: 0;
    width: 0.1875rem;
    background: transparent;
  }

  ${({$selected:e,theme:t})=>e?de`
          border: 1px solid ${t.colors["main-opacity"][500]};
          background: ${t.colors["main-opacity"][100]};

          &::before {
            background: ${t.colors.main[500]};
          }
        `:de`
          border: 1px solid rgba(255, 255, 255, 0.07);
          background: #0f141a;
        `}

  &:hover {
    filter: brightness(1.08);
  }
`,ME=C.span`
  width: 2.25rem;
  height: 2.25rem;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 0.5625rem;
  border: 1px solid
    ${({$selected:e,theme:t})=>e?t.colors["main-opacity"][300]:"rgba(255, 255, 255, 0.07)"};
  background: ${({$selected:e,theme:t})=>e?t.colors["main-opacity"][100]:"rgba(255, 255, 255, 0.05)"};
  color: ${({$selected:e,theme:t})=>e?t.colors.main[500]:"rgba(255, 255, 255, 0.62)"};

  svg {
    width: 1.1875rem;
    height: 1.1875rem;
  }
`,RE=C.div`
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 0.1875rem;
`,F0=C.strong`
  min-width: 0;
  overflow: hidden;
  color: rgba(255, 255, 255, 0.94);
  font-size: 0.90625rem;
  font-weight: 600;
  line-height: normal;
  text-overflow: ellipsis;
  white-space: nowrap;
`;C.span`
  min-width: 0;
  overflow: hidden;
  color: rgba(255, 255, 255, 0.42);
  font-size: 0.78125rem;
  font-weight: 400;
  line-height: normal;
  text-overflow: ellipsis;
  white-space: nowrap;
`;const W5=C.span`
  flex: none;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0.25rem 0.625rem;
  border-radius: 999px;
  background: ${({$enabled:e})=>e?"rgba(38, 230, 124, 0.14)":"rgba(255, 77, 82, 0.14)"};
  color: ${({$enabled:e})=>e?"#26e67c":"#ff4d52"};
  font-size: 0.75rem;
  font-weight: 500;
  line-height: normal;
  white-space: nowrap;
`,z0=C.span`
  min-width: 0;
  display: inline-flex;
  align-items: center;
  justify-content: flex-start;
  gap: 0.4375rem;
  color: rgba(255, 255, 255, 0.6);
  font-size: 0.78125rem;
  font-weight: 500;
  line-height: normal;
  white-space: nowrap;

  svg {
    width: 0.9375rem;
    height: 0.9375rem;
    flex: none;
    color: rgba(255, 255, 255, 0.4);
  }
`,$E=C.div`
  flex: 1;
  min-height: 0;
  display: flex;
  flex-direction: column;
  gap: 1rem;
  overflow: hidden;
`,LE=C.div`
  flex: 0 1 auto;
  min-height: 0;
  display: flex;
  flex-direction: column;
  gap: 1.125rem;
  overflow-y: auto;
  overflow-x: hidden;
  padding-right: 0.375rem;

  ${es}
`,NE=C.div`
  width: 100%;
  flex: none;
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
  padding-top: 0.125rem;
`,$c=C.section`
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 0.625rem;
`,Lc=C.strong`
  color: ${({theme:e})=>e.colors.main[500]};
  font-size: 0.8125rem;
  font-weight: 600;
  line-height: normal;
`,V0=C.div`
  width: 100%;
  display: flex;
  align-items: ${({$compact:e})=>e?"center":"flex-start"};
  gap: ${({$compact:e})=>e?"0.875rem":"1rem"};
  padding: ${({$compact:e})=>e?"1rem":"1.125rem"};
  border-radius: 0.75rem;
  border: 1px solid rgba(255, 255, 255, 0.07);
  background: #0f141a;
`,_E=C.button`
  width: 2.5rem;
  height: 1.4375rem;
  flex: none;
  display: flex;
  align-items: center;
  border-radius: 999px;
  transition:
    background 0.15s ease,
    border-color 0.15s ease,
    filter 0.15s ease;

  ${({$checked:e,theme:t})=>e?de`
          border: 1px solid transparent;
          background: ${t.colors.main[500]};
        `:de`
          border: 1px solid rgba(255, 255, 255, 0.1);
          background: #151c23;
        `}

  &::after {
    content: "";
    width: 1.0625rem;
    height: 1.0625rem;
    border-radius: 50%;
    background: ${({$checked:e})=>e?"#ffffff":"rgba(255, 255, 255, 0.45)"};
    transform: translateX(${({$checked:e})=>e?"1.3125rem":"0.125rem"});
    transition:
      transform 0.15s ease,
      background 0.15s ease;
  }

  &:hover {
    filter: brightness(1.08);
  }
`,FE=C(W5)`
  margin-left: auto;
`,zE=C.div`
  width: 100%;
  display: grid;
  grid-template-columns: minmax(0, 1fr);
  gap: 1rem;
`,VE=C.label`
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
`,jE=C.span`
  color: rgba(255, 255, 255, 0.6);
  font-size: 0.78125rem;
  font-weight: 500;
  line-height: normal;
`,BE=C.span`
  min-width: 0;
  color: rgba(255, 255, 255, 0.4);
  font-size: 0.71875rem;
  font-weight: 400;
  line-height: 1.35;
`,UE=C.div`
  position: relative;
  height: 3rem;
  width: 100%;

  svg {
    position: absolute;
    top: 50%;
    right: 0.75rem;
    width: 0.625rem;
    height: 0.625rem;
    color: rgba(255, 255, 255, 0.4);
    transform: translateY(-50%);
    pointer-events: none;
  }
`,HE=C.select`
  width: 100%;
  height: 3rem;
  appearance: none;
  border-radius: 0.5rem;
  border: 1px solid rgba(255, 255, 255, 0.1);
  background: #0a0d11;
  color: rgba(255, 255, 255, 0.62);
  padding: 0 2rem 0 0.875rem;
  font-size: 0.9375rem;
  font-weight: 600;
  line-height: normal;
`,WE=C.input`
  width: 2.875rem;
  height: 2.5rem;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: 0.5rem;
  border: 1px solid rgba(255, 255, 255, 0.1);
  background: #0a0d11;
  color: rgba(255, 255, 255, 0.95);
  font-size: 1rem;
  font-weight: 700;
  line-height: normal;
  text-align: center;

  &::-webkit-outer-spin-button,
  &::-webkit-inner-spin-button {
    margin: 0;
    appearance: none;
  }
`,sd=C.button`
  width: 2.5rem;
  height: 2.5rem;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: 0.5rem;
  border: 1px solid rgba(255, 255, 255, 0.1);
  background: #0f141a;
  color: rgba(255, 255, 255, 0.95);
  transition:
    filter 0.15s ease,
    border-color 0.15s ease;

  svg {
    width: 1rem;
    height: 1rem;
  }

  &:hover {
    filter: brightness(1.12);
    border-color: rgba(255, 255, 255, 0.18);
  }
`,GE=C.button`
  width: 3.75rem;
  height: 2.5rem;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: 0.5rem;
  border: 1px solid rgba(255, 255, 255, 0.1);
  background: #0f141a;
  color: rgba(255, 255, 255, 0.62);
  font-size: 0.8125rem;
  font-weight: 600;
  line-height: normal;
  transition:
    filter 0.15s ease,
    color 0.15s ease,
    border-color 0.15s ease;

  &:hover {
    color: rgba(255, 255, 255, 0.9);
    filter: brightness(1.1);
    border-color: rgba(255, 255, 255, 0.18);
  }
`,KE=C.div`
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  padding: 0.875rem;
  border-radius: 0.75rem;
  border: 1px solid rgba(255, 255, 255, 0.07);
  background: #0f141a;
  overflow-y: auto;
  overflow-x: hidden;

  ${es}
`,YE=C.div`
  width: 100%;
  flex: none;
  display: grid;
  grid-template-columns: 2.5rem minmax(0, 1fr) 2.5rem 2.875rem 2.5rem 3.75rem 2.25rem;
  align-items: center;
  gap: 0.5rem;
  padding: 0.5rem 0.625rem;
  border-radius: 0.625rem;
  border: 1px solid rgba(255, 255, 255, 0.05);
  background: rgba(255, 255, 255, 0.03);
`,j0=C.span`
  width: 2.5rem;
  height: 2.5rem;
  display: inline-flex;
  align-items: center;
  justify-content: center;
`,B0=C.img`
  width: 2.5rem;
  height: 2.5rem;
  object-fit: contain;
  object-position: center;
`,U0=C.strong`
  min-width: 0;
  margin-left: 0.25rem;
  overflow: hidden;
  color: rgba(255, 255, 255, 0.92);
  font-size: 0.875rem;
  font-weight: 600;
  line-height: normal;
  text-overflow: ellipsis;
  white-space: nowrap;
`,QE=C(sd)`
  width: 2.25rem;
  height: 2.25rem;
  border-radius: 0.5625rem;
  border-color: rgba(255, 255, 255, 0.07);
  color: rgba(255, 255, 255, 0.46);

  svg {
    width: 1rem;
    height: 1rem;
  }

  &:hover {
    color: #ff4d52;
  }
`,XE=C.button`
  width: 100%;
  flex: none;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.625rem;
  padding: 0.875rem 0;
  border-radius: 0.6875rem;
  border: 1px dashed ${({theme:e})=>e.colors["main-opacity"][300]};
  background: ${({theme:e})=>e.colors["main-opacity"][50]};
  color: ${({theme:e})=>e.colors.main[500]};
  font-size: 0.875rem;
  font-weight: 600;
  line-height: 1;
  transition:
    filter 0.15s ease,
    background 0.15s ease;

  svg {
    width: 1.125rem;
    height: 1.125rem;
  }

  &:hover {
    filter: brightness(1.08);
    background: ${({theme:e})=>e.colors["main-opacity"][100]};
  }
`,qE=C.div`
  position: absolute;
  inset: 0;
  z-index: 5;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 1.75rem;
  background: rgba(4, 7, 10, 0.68);
  backdrop-filter: blur(0.1875rem);
`,ZE=C.div`
  width: min(28rem, 100%);
  max-height: min(35rem, calc(100vh - 7rem));
  display: flex;
  flex-direction: column;
  gap: 1rem;
  padding: 1rem;
  border-radius: 0.875rem;
  border: 1px solid rgba(255, 255, 255, 0.1);
  background: #0c1015;
  box-shadow: 0 1rem 2.5rem rgba(0, 0, 0, 0.55);
`,JE=C.div`
  width: 100%;
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 1rem;
`,e9=C.strong`
  display: block;
  color: rgba(255, 255, 255, 0.96);
  font-size: 1rem;
  font-weight: 800;
  line-height: normal;
`,t9=C.span`
  display: block;
  margin-top: 0.25rem;
  color: rgba(255, 255, 255, 0.46);
  font-size: 0.75rem;
  font-weight: 400;
  line-height: 1.35;
`,n9=C.label`
  width: 100%;
  height: 2.75rem;
  display: flex;
  align-items: center;
  gap: 0.625rem;
  padding: 0 0.875rem;
  border-radius: 0.625rem;
  border: 1px solid rgba(255, 255, 255, 0.08);
  background: #0f141a;
  color: rgba(255, 255, 255, 0.45);

  svg {
    width: 1rem;
    height: 1rem;
    flex: none;
  }
`,r9=C.input`
  width: 100%;
  min-width: 0;
  height: 100%;
  border: 0;
  outline: 0;
  background: transparent;
  color: rgba(255, 255, 255, 0.9);
  font-size: 0.875rem;
  font-weight: 400;
  line-height: normal;

  &::placeholder {
    color: rgba(255, 255, 255, 0.4);
  }
`,o9=C.div`
  width: 100%;
  max-height: 23rem;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  padding-right: 0.375rem;
  overflow-y: auto;
  overflow-x: hidden;

  ${es}
`,i9=C.button`
  width: 100%;
  min-height: 4.125rem;
  flex: none;
  display: grid;
  grid-template-columns: 3rem minmax(0, 1fr);
  align-items: center;
  gap: 0.875rem;
  padding: 0.75rem 1rem;
  border-radius: 0.75rem;
  border: 1px solid rgba(255, 255, 255, 0.07);
  background: #151a20;
  text-align: left;
  transition:
    filter 0.15s ease,
    border-color 0.15s ease,
    background 0.15s ease;

  &:hover {
    filter: brightness(1.08);
    border-color: ${({theme:e})=>e.colors["main-opacity"][300]};
    background: #171f26;
  }
`,H0=C.span`
  min-height: 4.125rem;
  display: flex;
  align-items: center;
  padding: 0 1rem;
  border-radius: 0.75rem;
  border: 1px solid rgba(255, 255, 255, 0.07);
  background: #151a20;
  color: rgba(255, 255, 255, 0.46);
  font-size: 0.8125rem;
  font-weight: 400;
`,s9=C.div`
  position: absolute;
  inset: 0;
  z-index: 6;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 1.75rem;
  background: rgba(4, 7, 10, 0.72);
  backdrop-filter: blur(0.1875rem);
`,a9=C.div`
  width: min(27rem, 100%);
  display: flex;
  flex-direction: column;
  gap: 0.875rem;
  padding: 1.25rem;
  border-radius: 0.875rem;
  border: 1px solid rgba(255, 255, 255, 0.1);
  background: #0c1015;
  box-shadow: 0 1rem 2.5rem rgba(0, 0, 0, 0.55);
`,l9=C.strong`
  color: rgba(255, 255, 255, 0.96);
  font-size: 1rem;
  font-weight: 800;
  line-height: normal;
`,c9=C.p`
  color: rgba(255, 255, 255, 0.55);
  font-size: 0.8125rem;
  font-weight: 400;
  line-height: 1.45;
`,u9=C.div`
  width: 100%;
  display: grid;
  grid-template-columns: minmax(0, 1fr) minmax(0, 1fr);
  gap: 0.75rem;
  margin-top: 0.25rem;
`,W0=C.button`
  min-height: 2.75rem;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0 0.875rem;
  border-radius: 0.625rem;
  font-size: 0.8125rem;
  font-weight: 700;
  line-height: normal;
  transition:
    filter 0.15s ease,
    border-color 0.15s ease,
    background 0.15s ease;

  ${({$danger:e})=>e?de`
          border: 1px solid rgba(255, 77, 82, 0.35);
          background: rgba(255, 77, 82, 0.12);
          color: #ff4d52;
        `:de`
          border: 1px solid rgba(255, 255, 255, 0.1);
          background: #0f141a;
          color: rgba(255, 255, 255, 0.86);
        `}

  &:hover {
    filter: brightness(1.08);
    border-color: ${({$danger:e})=>e?"rgba(255, 77, 82, 0.55)":"rgba(255, 255, 255, 0.18)"};
  }
`,G0=C.button`
  width: 100%;
  height: 3rem;
  flex: none;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: 0.5rem;
  border: 1px solid ${({theme:e})=>e.colors.main[500]};
  background: ${({theme:e})=>e.colors.main[500]};
  color: #ffffff;
  font-size: 0.9375rem;
  font-weight: 600;
  letter-spacing: -0.009375rem;
  line-height: normal;
  transition: filter 0.15s ease;

  &:hover {
    filter: brightness(1.06);
  }
`,K0=C.span`
  flex: none;
  display: flex;
  align-items: center;
  min-height: 3rem;
  padding: 0 0.875rem;
  color: rgba(255, 255, 255, 0.4);
  font-size: 0.8125rem;
  font-weight: 400;
`,d9=C.footer`
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: flex-start;
  gap: 0.75rem;
  padding-top: 1.125rem;
  border-top: 1px solid rgba(255, 255, 255, 0.07);
`,f9=C.span`
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0.375rem 0.6875rem;
  border-radius: 0.4375rem;
  border: 1px solid rgba(255, 255, 255, 0.14);
  background: rgba(255, 255, 255, 0.06);
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.6875rem;
  font-weight: 700;
  letter-spacing: 0.04125rem;
  line-height: normal;
`,h9=C.span`
  min-width: 0;
  color: rgba(255, 255, 255, 0.5);
  font-size: 0.8125rem;
  font-weight: 400;
  line-height: normal;
`;C.button`
  height: 3rem;
  flex: none;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0 1.25rem;
  border-radius: 0.5rem;
  font-size: 0.9375rem;
  font-weight: 600;
  transition:
    filter 0.15s ease,
    background 0.15s ease,
    border-color 0.15s ease;

  ${({$primary:e,theme:t})=>e?de`
          border: 1px solid ${t.colors.main[500]};
          background: ${t.colors.main[500]};
          color: #ffffff;
        `:de`
          border: 1px solid rgba(255, 255, 255, 0.1);
          background: #0f141a;
          color: rgba(255, 255, 255, 0.95);
        `}

  &:hover {
    filter: brightness(1.08);
  }
`;const gr=[5,10,15,30,60],Y0=[{id:"pistol",key:"weapon_pistol",index:"weapon_pistol",name:"Pistola",amount:1,maxAmount:10},{id:"ammo-9mm",key:"ammo_9mm",index:"ammo_9mm",name:"Muni\xE7\xE3o 9mm",amount:120,maxAmount:300},{id:"vest",key:"vest",index:"vest",name:"Colete",amount:1,maxAmount:10}],ni=[{id:"acetone",key:"acetone",index:"acetone",name:"Acetona",defaultAmount:1,maxAmount:20},{id:"adrenaline",key:"adrenaline",index:"adrenaline",name:"Adrenalina",defaultAmount:1,maxAmount:20},{id:"handcuffs",key:"handcuffs",index:"handcuffs",name:"Algemas",defaultAmount:1,maxAmount:10},{id:"bandage",key:"bandage",index:"bandage",name:"Bandagem",defaultAmount:1,maxAmount:50},{id:"hood",key:"hood",index:"hood",name:"Capuz",defaultAmount:1,maxAmount:10}],G5=[{id:"lider-00",name:"L\xEDder 00",enabled:!1,cooldownMinutes:5,intervalOptions:gr,itemsCount:Y0.length,kitItems:Y0},{id:"lider-01",name:"L\xEDder 01",enabled:!1,cooldownMinutes:5,intervalOptions:gr,itemsCount:0,kitItems:[]},{id:"lider-02",name:"L\xEDder 02",enabled:!1,cooldownMinutes:5,intervalOptions:gr,itemsCount:0,kitItems:[]},{id:"lider-03",name:"L\xEDder 03",enabled:!1,cooldownMinutes:5,intervalOptions:gr,itemsCount:0,kitItems:[]},{id:"gerente-geral",name:"Gerente Geral",enabled:!1,cooldownMinutes:5,intervalOptions:gr,itemsCount:0,kitItems:[]},{id:"gerente-farm",name:"Gerente de Farm",enabled:!1,cooldownMinutes:5,intervalOptions:gr,itemsCount:0,kitItems:[]}],K5=()=>({label:"Posi\xE7\xE3o marcada nesta sess\xE3o"}),ad=(e,t="Los Santos Vagos")=>{const n=e==="configured";return{title:"Arsenal \u2014 Bennys",factionName:t,hasPosition:n,position:n?K5():void 0,roles:G5,canSetPosition:!0,canConfigureRoles:n,canDisableAllRoles:n}},Nc=(e,t,n)=>{var i,s,a,l,c,u;const r=ad(t,n);if(!e)return r;const o=(s=e.hasPosition)!=null?s:Boolean((i=e.position)!=null?i:r.position);return{...r,...e,hasPosition:o,position:(a=e.position)!=null?a:r.position,roles:(l=e.roles)!=null?l:r.roles,canConfigureRoles:(c=e.canConfigureRoles)!=null?c:o,canDisableAllRoles:(u=e.canDisableAllRoles)!=null?u:o}},Ht=(e,t)=>{Oe(e,t)},Ts=e=>e.normalize("NFD").replace(/[\u0300-\u036f]/g,"").toLowerCase(),Mn=e=>{var t;return(t=e==null?void 0:e.kitItems)!=null?t:[]},p9=e=>{var t;return(t=e.itemsCount)!=null?t:Mn(e).length},m9=e=>{var t,n;return e.image?e.image:nn(String((n=(t=e.key)!=null?t:e.index)!=null?n:e.id))},g9=e=>{var t,n;return e.image?e.image:nn(String((n=(t=e.key)!=null?t:e.index)!=null?n:e.id))},_c=e=>JSON.parse(JSON.stringify(e)),Q0=e=>{var t,n;return JSON.stringify({enabled:(t=e==null?void 0:e.enabled)!=null?t:!1,cooldownMinutes:(n=e==null?void 0:e.cooldownMinutes)!=null?n:5,kitItems:Mn(e).map(r=>({id:r.id,key:r.key,index:r.index,name:r.name,amount:r.amount,maxAmount:r.maxAmount,image:r.image}))})},y9=e=>{var t;return Array.isArray(e)?e:(t=e==null?void 0:e.items)!=null?t:ni},v9=[{id:"position",icon:f(H5,{})},{id:"roles",icon:f(fo,{})},{id:"enable",icon:f(rd,{})},{id:"cooldown",icon:f(U5,{})},{id:"kit",icon:f(j5,{})},{id:"disable-all",icon:f(SP,{})}];function Es({stateOverride:e}){var _r,Fr,Bt,eh,th,nh,rh,oh,ih;const{t}=Zt(),n=t("factionArsenal.fallbackFactionName"),[r,o]=v.exports.useState(()=>ad(e,n)),[i,s]=v.exports.useState("home"),[a,l]=v.exports.useState(""),[c,u]=v.exports.useState((_r=G5[0])==null?void 0:_r.id),[d,p]=v.exports.useState(!1),[y,w]=v.exports.useState(!1),[x,b]=v.exports.useState(""),[g,h]=v.exports.useState(ni),[m,S]=v.exports.useState(),[E,T]=v.exports.useState(!1);v.exports.useEffect(()=>{var be;let D=!0;const Q=ad(e,n);return o(Q),s("home"),l(""),u((be=Q.roles[0])==null?void 0:be.id),p(!1),b(""),h(ni),S(void 0),T(!1),Oe("requestFactionArsenalConfig",{state:e},Q).then(Ee=>{var It;if(!D)return;const Fe=Nc(Ee,e,n);o(Fe),u((It=Fe.roles[0])==null?void 0:It.id)}).catch(()=>{!D||o(Q)}),()=>{D=!1}},[n,e]),v.exports.useEffect(()=>{if(r.roles.length===0){u(void 0),S(void 0),T(!1),s(Q=>Q==="role-detail"?"roles":Q);return}r.roles.some(Q=>String(Q.id)===String(c))||u(r.roles[0].id)},[r.roles,c]),ot("updateFactionArsenalConfig",D=>{o(Q=>Nc({...Q,...D},e,n))}),ot("factionArsenal:update",D=>{o(Q=>Nc({...Q,...D},e,n))});const I=(Fr=r.hasPosition)!=null?Fr:Boolean(r.position),O=(Bt=r.canSetPosition)!=null?Bt:!0,L=Boolean(I&&((eh=r.canConfigureRoles)!=null?eh:!0)),_=Boolean(I&&((th=r.canDisableAllRoles)!=null?th:!0)),re=I,J=(nh=r.title)!=null?nh:"Arsenal \u2014 Bennys",[se,j]=J.split(/\s*[—-]\s*/,2),Y=j?`${se}\u2014${j}`:J,z=v.exports.useMemo(()=>{var D;return(D=r.roles.find(Q=>String(Q.id)===String(c)))!=null?D:r.roles[0]},[r.roles,c]),ee=Mn(z),$=(rh=z==null?void 0:z.intervalOptions)!=null&&rh.length?z.intervalOptions:gr,B=v.exports.useMemo(()=>i!=="role-detail"||!z||!m?!1:Q0(z)!==Q0(m),[m,z,i]),G=v.exports.useMemo(()=>{const D=Ts(a.trim());return D?r.roles.filter(Q=>{var Ee;return Ts(`${Q.name} ${(Ee=Q.description)!=null?Ee:""} ${String(Q.id)}`).includes(D)}):r.roles},[r.roles,a]),W=v.exports.useMemo(()=>{const D=Ts(x.trim());return D?g.filter(Q=>{var Ee,Fe;return Ts(`${Q.name} ${String((Ee=Q.key)!=null?Ee:"")} ${String((Fe=Q.index)!=null?Fe:"")} ${String(Q.id)}`).includes(D)}):g},[g,x]),R=D=>{!z||o(Q=>({...Q,roles:Q.roles.map(be=>String(be.id)===String(z.id)?D(be):be)}))},F=()=>{!O||(o(D=>{var Q;return{...D,hasPosition:!0,position:(Q=D.position)!=null?Q:K5(),canConfigureRoles:!0,canDisableAllRoles:!0}}),Ht("factionArsenalSetPosition",{currentPosition:r.position}))},V=()=>{var D;!L||(s("roles"),l(""),u((D=r.roles[0])==null?void 0:D.id),Ht("factionArsenalOpenRoles",{visible:!0}))},X=()=>{s("home"),l(""),Ht("factionArsenalOpenRoles",{visible:!1})},k=()=>{T(!1),ae(),S(void 0),s("roles"),Ht("factionArsenalOpenRoleDetail",{visible:!1,roleId:z==null?void 0:z.id})},U=()=>{if(i==="role-detail"){if(B){ae(),T(!0);return}k();return}X()},M=D=>{ae(),T(!1),S(_c(D)),u(D.id),s("role-detail"),Ht("factionArsenalSelectRole",{roleId:D.id,role:D}),Ht("factionArsenalOpenRoleDetail",{visible:!0,roleId:D.id,role:D})},ue=()=>{R(D=>({...D,enabled:!D.enabled}))},te=D=>{R(Q=>({...Q,cooldownMinutes:D}))},le=(D,Q)=>{R(be=>{const Ee=Mn(be).map(Fe=>{var lr;if(String(Fe.id)!==String(D.id))return Fe;const It=(lr=Fe.maxAmount)!=null?lr:999;return{...Fe,amount:Math.min(It,Math.max(1,Fe.amount+Q))}});return{...be,kitItems:Ee,itemsCount:Ee.length}})},A=(D,Q)=>{const be=Number(Q.replace(/\D/g,""));!Number.isFinite(be)||R(Ee=>{const Fe=Mn(Ee).map(It=>{var Ot;if(String(It.id)!==String(D.id))return It;const lr=(Ot=It.maxAmount)!=null?Ot:999;return{...It,amount:Math.min(lr,Math.max(1,be||1))}});return{...Ee,kitItems:Fe,itemsCount:Fe.length}})},H=D=>{R(Q=>{const be=Mn(Q).map(Ee=>{var Fe;return String(Ee.id)===String(D.id)?{...Ee,amount:(Fe=Ee.maxAmount)!=null?Fe:Ee.amount}:Ee});return{...Q,kitItems:be,itemsCount:be.length}})},Z=D=>{R(Q=>{const be=Mn(Q).filter(Ee=>String(Ee.id)!==String(D.id));return{...Q,kitItems:be,itemsCount:be.length}})},q=()=>{!z||(p(!0),w(!0),b(""),Oe("requestFactionArsenalKitItems",{roleId:z.id,role:z,currentKitItems:ee},{items:ni}).then(D=>{h(y9(D))}).catch(()=>{h(ni)}).finally(()=>{w(!1)}))},ae=()=>{p(!1),b("")},ie=D=>{var be;if(!z)return;const Q=(be=D.defaultAmount)!=null?be:1;R(Ee=>{const Fe=Mn(Ee),It=Fe.find(Ot=>String(Ot.id)===String(D.id)||D.key!==void 0&&String(Ot.key)===String(D.key)||D.index!==void 0&&String(Ot.index)===String(D.index)),lr=It?Fe.map(Ot=>{var ah,lh;if(String(Ot.id)!==String(It.id))return Ot;const sh=(lh=(ah=Ot.maxAmount)!=null?ah:D.maxAmount)!=null?lh:999;return{...Ot,amount:Math.min(sh,Ot.amount+Q),maxAmount:sh}}):[...Fe,{id:D.id,key:D.key,index:D.index,name:D.name,image:D.image,amount:Q,maxAmount:D.maxAmount}];return{...Ee,kitItems:lr,itemsCount:lr.length}}),Ht("factionArsenalAddRoleKitItem",{roleId:z.id,item:D,role:z}),ae()},ge=()=>{var D;!z||(S(_c(z)),T(!1),Ht("factionArsenalSaveRoleConfig",{roleId:z.id,enabled:z.enabled,cooldownMinutes:(D=z.cooldownMinutes)!=null?D:5,kitItems:ee,role:z}))},we=()=>{!_||(o(D=>({...D,roles:D.roles.map(Q=>({...Q,enabled:!1}))})),Ht("factionArsenalDisableAllRoles",{}))},xe=()=>{!I||(o(D=>({...D,hasPosition:!1,position:void 0,roles:D.roles.map(Q=>({...Q,enabled:!1})),canConfigureRoles:!1,canDisableAllRoles:!1})),s("home"),l(""),S(void 0),T(!1),ae(),Ht("factionArsenalRemovePosition",{}))},st=()=>{ae(),s("help")},he=()=>{s("home")},Te=()=>{if(i==="role-detail"){U();return}if(i==="roles"){X();return}if(i==="help"){he();return}Ht("factionArsenalClose",{})},oe=()=>{T(!1)},De=()=>{z&&m&&o(D=>({...D,roles:D.roles.map(Q=>String(Q.id)===String(z.id)?_c(m):Q)})),k()};return f(rE,{"data-faction-arsenal-state":I?"configured":"unset",children:P(oE,{$view:i,children:[P(iE,{children:[f(sE,{children:P(lE,{children:[f(cE,{children:i==="help"?t("factionArsenal.howItWorks"):i==="roles"&&j?P(pe,{children:[se,"\u2014",f("br",{}),j]}):i==="role-detail"?Y:J}),f(uE,{children:i==="help"?t("factionArsenal.helpSubtitle"):(oh=r.factionName)!=null?oh:n})]})}),f(aE,{children:i==="help"?f(Rc,{onClick:he,"aria-label":t("factionArsenal.close"),children:f(Ws,{})}):i==="home"?P(pe,{children:[f(dE,{type:"button",onClick:st,"aria-label":t("factionArsenal.howItWorks"),children:f(s0,{})}),f(Rc,{onClick:Te,"aria-label":t("factionArsenal.close"),children:f(Ws,{})})]}):P(pe,{children:[i==="role-detail"&&z&&P(hE,{children:[f(fo,{}),f("span",{children:z.name})]}),f(fE,{type:"button",$large:i==="role-detail",onClick:U,"aria-label":t("factionArsenal.back"),children:f(yP,{})})]})})]}),i==="help"?P(pe,{children:[f(mE,{children:v9.map(D=>P(gE,{children:[f(yE,{children:D.icon}),P(vE,{children:[f(xE,{children:t(`factionArsenal.helpTopics.${D.id}.title`)}),f(wE,{children:t(`factionArsenal.helpTopics.${D.id}.description`)})]})]},D.id))}),P(bE,{children:[f(CE,{children:f(s0,{})}),P(SE,{children:[f(kE,{children:t("factionArsenal.important")}),f(PE,{children:t("factionArsenal.stockNotice")})]})]}),f(G0,{type:"button",onClick:he,children:t("factionArsenal.understood")})]}):i==="role-detail"&&z?P($E,{children:[P(LE,{children:[P($c,{children:[f(Lc,{children:t("factionArsenal.roleArsenalSection")}),P(V0,{$compact:!0,children:[f(_E,{type:"button",$checked:z.enabled,onClick:ue,"aria-label":z.enabled?t("factionArsenal.deactivateArsenal"):t("factionArsenal.activateArsenal")}),f(F0,{children:t("factionArsenal.activateArsenal")}),f(FE,{$enabled:z.enabled,children:z.enabled?t("factionArsenal.enabled"):t("factionArsenal.disabled")})]})]}),P($c,{children:[f(Lc,{children:t("factionArsenal.withdrawRulesSection")}),f(V0,{children:f(zE,{children:P(VE,{children:[f(jE,{children:t("factionArsenal.interval")}),P(UE,{children:[f(HE,{value:(ih=z.cooldownMinutes)!=null?ih:5,onChange:D=>{te(Number(D.target.value))},children:$.map(D=>P("option",{value:D,children:[D," min"]},D))}),f(B5,{})]}),f(BE,{children:t("factionArsenal.withdrawAgainHint")})]})})})]}),P($c,{children:[f(Lc,{children:t("factionArsenal.kitItemsSection",ee.length)}),f(KE,{children:ee.length===0?f(K0,{children:t("factionArsenal.emptyKit")}):ee.map(D=>P(YE,{children:[f(j0,{children:f(B0,{src:m9(D),alt:"",onError:({currentTarget:Q})=>{Q.onerror=null,Q.src=nn("no-image")}})}),f(U0,{children:D.name}),f(sd,{type:"button",onClick:()=>{le(D,-1)},children:f(xP,{})}),f(WE,{type:"number",min:1,max:D.maxAmount,step:1,inputMode:"numeric",value:D.amount,onChange:Q=>{A(D,Q.currentTarget.value)},"aria-label":t("factionArsenal.itemQuantity",D.name)}),f(sd,{type:"button",onClick:()=>{le(D,1)},children:f(a0,{})}),f(GE,{type:"button",onClick:()=>{H(D)},children:t("factionArsenal.max")}),f(QE,{type:"button",onClick:()=>{Z(D)},"aria-label":t("factionArsenal.removeItem",D.name),children:f(c0,{})})]},String(D.id)))})]})]}),P(NE,{children:[P(XE,{type:"button",onClick:q,children:[f(a0,{}),f("span",{children:t("factionArsenal.addItem")})]}),f(G0,{type:"button",onClick:ge,children:t("factionArsenal.saveChanges")})]}),d&&f(qE,{children:P(ZE,{children:[P(JE,{children:[P("div",{children:[f(e9,{children:t("factionArsenal.addItem")}),f(t9,{children:t("factionArsenal.itemPickerSubtitle")})]}),f(Rc,{type:"button",onClick:ae,"aria-label":t("factionArsenal.closeItemList"),children:f(Ws,{})})]}),P(n9,{children:[f(l0,{}),f(r9,{value:x,onChange:D=>{b(D.target.value)},placeholder:t("factionArsenal.searchItemPlaceholder"),"aria-label":t("factionArsenal.searchItem")})]}),f(o9,{"data-arsenal-item-picker-list":!0,children:y?f(H0,{children:t("factionArsenal.loadingItems")}):W.length===0?f(H0,{children:t("factionArsenal.noItemFound")}):W.map(D=>P(i9,{type:"button",onClick:()=>{ie(D)},"data-arsenal-item-picker-row":!0,children:[f(j0,{children:f(B0,{src:g9(D),alt:"",onError:({currentTarget:Q})=>{Q.onerror=null,Q.src=nn("no-image")}})}),f(U0,{children:D.name})]},String(D.id)))})]})}),E&&f(s9,{"data-arsenal-discard-confirm":!0,children:P(a9,{children:[f(l9,{children:t("factionArsenal.discardTitle")}),f(c9,{children:t("factionArsenal.discardDescription")}),P(u9,{children:[f(W0,{type:"button",onClick:oe,children:t("factionArsenal.continueEditing")}),f(W0,{type:"button",$danger:!0,onClick:De,children:t("factionArsenal.discardAndBack")})]})]})})]}):i==="roles"?P(pe,{children:[P(TE,{children:[P(EE,{children:[f(l0,{}),f(IE,{value:a,onChange:D=>{l(D.target.value)},placeholder:t("factionArsenal.searchRolePlaceholder"),"aria-label":t("factionArsenal.searchRole")})]}),f(OE,{children:t("factionArsenal.rolesCount",G.length)})]}),f(AE,{"data-arsenal-roles-list":!0,children:G.length===0?f(K0,{children:t("factionArsenal.noRoleFound")}):G.map(D=>{var be;const Q=String(c)===String(D.id);return P(DE,{type:"button",$selected:Q,onClick:()=>{M(D)},"data-arsenal-role-row":!0,children:[f(ME,{$selected:Q,children:f(fo,{})}),f(RE,{children:f(F0,{children:D.name})}),f(W5,{$enabled:D.enabled,children:D.enabled?t("factionArsenal.enabled"):t("factionArsenal.disabled")}),P(z0,{children:[f(U5,{}),P("span",{children:[(be=D.cooldownMinutes)!=null?be:5," min"]})]}),P(z0,{children:[f(j5,{}),f("span",{children:t("factionArsenal.itemsCount",p9(D))})]})]},String(D.id))})})]}):P(pE,{children:[!I&&P(pe,{children:[P(Dn,{type:"button",disabled:!0,"data-arsenal-configure-roles":!0,children:[f(Br,{children:f(fo,{})}),P(Ur,{children:[f(Hr,{children:t("factionArsenal.configureRoles")}),f(Wr,{children:t("factionArsenal.setupPositionFirst")})]})]}),P(Dn,{type:"button",disabled:!0,"data-arsenal-disable-all":!0,children:[f(Br,{children:f(rd,{})}),P(Ur,{children:[f(Hr,{children:t("factionArsenal.toggleAllRoles")}),f(Wr,{children:t("factionArsenal.toggleAllRolesDescription")})]})]})]}),I&&P(pe,{children:[P(Dn,{type:"button",$primary:!0,disabled:!L,onClick:V,"data-arsenal-configure-roles":!0,children:[f(Br,{children:f(fo,{})}),P(Ur,{children:[f(Hr,{children:t("factionArsenal.configureRoles")}),f(Wr,{children:t("factionArsenal.configureRolesDescription")})]})]}),P(Dn,{type:"button",disabled:!_,onClick:we,"data-arsenal-disable-all":!0,children:[f(Br,{children:f(rd,{})}),P(Ur,{children:[f(Hr,{children:t("factionArsenal.toggleAllRoles")}),f(Wr,{children:t("factionArsenal.toggleAllRolesDescription")})]})]})]}),P(Dn,{type:"button",$primary:!I,disabled:!O,onClick:F,"data-arsenal-set-position":!0,children:[f(Br,{children:f(H5,{})}),P(Ur,{children:[f(Hr,{children:t(I?"factionArsenal.editPosition":"factionArsenal.markPosition")}),f(Wr,{children:t(I?"factionArsenal.editPositionDescription":"factionArsenal.markPositionDescription")})]})]}),I&&P(Dn,{type:"button",$danger:!0,disabled:!re,onClick:xe,"data-arsenal-remove-position":!0,children:[f(Br,{children:f(c0,{})}),P(Ur,{children:[f(Hr,{children:t("factionArsenal.removePosition")}),f(Wr,{children:t("factionArsenal.removePositionDescription")})]})]})]}),i!=="help"&&P(d9,{$view:i,children:[f(f9,{children:"ESC"}),f(h9,{children:t(i==="home"?"factionArsenal.close":"factionArsenal.back")})]})]})})}function x9(){const{mainInventory:e,inventoryItems:t,secondaryInventory:n,updateMainInventory:r,updateSecondaryInventory:o}=Et(),{type:i}=vf();return v.exports.useEffect(()=>{r(),o(i)},[i]),P(mP,{children:[e?f(r0,{...e,items:t,isMain:!0}):f(i0,{}),f(Q7,{}),n?f(r0,{...n,isMain:!1}):f(i0,{})]})}const w9=C.div`
  width: 100%;
  height: 100vh;
`,b9=C.div`
  // width: 49.7%;
  width: max-content;
  height: 100%;
  display: flex;
  align-items: center;
  margin-left: 5%;
`,C9=C.div`
  width: 100%;

  display: grid;
  gap: 2.7rem;

  align-content: center;
  display: grid;

  grid-template-columns: var(--slot-width) 1fr;
  grid-template-rows: 6rem 1fr 8.5rem;
  grid-column-gap: 3.5rem;
  grid-row-gap: 2.5rem;

  transition: all 0.5s;
  ${({hiddenHeader:e})=>e&&de`
    grid-template-rows: 0rem 1fr 8.5rem !important;
  `}
`,S9=2,Y5=v.exports.createContext(null),k9=({children:e})=>{const[t,n]=v.exports.useState(!1),[r,o]=v.exports.useState(0),[i,s]=v.exports.useState([]),a=v.exports.useRef(new Set),l=v.exports.useCallback(g=>{try{const h=g.map((m,S)=>({i:S,target:m.target,advanceOnClick:m.advanceOnClick,advanceOnAnyClick:m.advanceOnAnyClick,advanceOnDrop:m.advanceOnDrop,advanceOnPath:m.advanceOnPath}));console.info("[InventoryTutorial] open \u2014 steps="+g.length+" summary="+JSON.stringify(h))}catch{}a.current=new Set,s(g),o(0),n(!0)},[]),c=v.exports.useCallback(()=>{n(!1),o(0)},[]),u=v.exports.useCallback(g=>{a.current.add(g)},[]),d=v.exports.useCallback(()=>a.current.size,[]),p=v.exports.useCallback(()=>{o(g=>g<i.length-1?g+1:(n(!1),0))},[i.length]),y=v.exports.useCallback(()=>{o(g=>g>0?g-1:g)},[]),w=v.exports.useCallback(g=>{o(g)},[]);ot("tutorialInventory:start",v.exports.useCallback(g=>{var h;!((h=g==null?void 0:g.steps)!=null&&h.length)||l(g.steps)},[l])),ot("tutorialInventory:close",v.exports.useCallback(()=>c(),[c])),ot("tutorialInventory:next",v.exports.useCallback(()=>p(),[p])),ot("tutorialInventory:prev",v.exports.useCallback(()=>y(),[y])),ot("tutorialInventory:goto",v.exports.useCallback(g=>w(g),[w])),v.exports.useEffect(()=>{const g=h=>{var T,I;const m=h.data;if(!m||typeof m!="object")return;const S=(T=m.action)!=null?T:m.type,E=m.data;S==="tutorialInventory:start"&&((I=E==null?void 0:E.steps)==null?void 0:I.length)?l(E.steps):S==="tutorialInventory:close"?c():S==="tutorialInventory:next"?p():S==="tutorialInventory:prev"?y():S==="tutorialInventory:goto"&&w(E)};return window.addEventListener("message",g),()=>window.removeEventListener("message",g)},[l,c,p,y,w]);const x=i[r],b=v.exports.useMemo(()=>({isOpen:t,currentStep:r,steps:i,step:x,open:l,close:c,next:p,prev:y,goTo:w,markEngaged:u,getEngagedCount:d}),[t,r,i,x,l,c,p,y,w,u,d]);return f(Y5.Provider,{value:b,children:e})},Q5=()=>{const e=v.exports.useContext(Y5);if(!e)throw new Error("useTutorial must be used within a TutorialProvider");return e},P9=C.div`
  position: fixed;
  inset: 0;
  z-index: 9999;
  pointer-events: none;
`,Is=C.div`
  position: absolute;
  background: rgba(0, 0, 0, 0.7);
  pointer-events: none;
`,T9=C.div`
  position: absolute;
  inset: 0;
  background: rgba(0, 0, 0, 0.7);
  pointer-events: auto;
`,E9=mf`
  0%, 100% { box-shadow: 0 0 0 0 color-mix(in srgb, var(--main-500, #ff830a) 45%, transparent); }
  50%      { box-shadow: 0 0 0 8px transparent;   }
`,I9=C.div`
  position: absolute;
  pointer-events: none;
  border: 2px solid var(--main-500, #ff830a);
  border-radius: 0.2rem;
  box-shadow: 0 0 0 0 color-mix(in srgb, var(--main-500, #ff830a) 45%, transparent);
  animation: ${E9} 1.6s ease-in-out infinite;
`,O9=mf`
  0%, 100% { transform: translateY(-50%) translateX(0);    opacity: 0.85; }
  50%      { transform: translateY(-50%) translateX(-8px); opacity: 1;    }
`,A9=mf`
  0%, 100% { transform: translateY(-50%) scaleX(-1) translateX(0);    opacity: 0.85; }
  50%      { transform: translateY(-50%) scaleX(-1) translateX(-8px); opacity: 1;    }
`,D9=C.div`
  position: absolute;
  pointer-events: none;
  width: 338px;
  height: 15px;
  color: var(--main-500, #ff830a);
  animation: ${({$flipped:e})=>e?A9:O9}
    1.4s ease-in-out infinite;
`,M9=C.div`
  position: absolute;
  background: linear-gradient(
      0deg,
      rgba(var(--rgb-color, 255, 131, 10), 0.09) 0%,
      rgba(var(--rgb-color, 255, 131, 10), 0.09) 100%
    ),
    rgba(0, 0, 0, 0.59);
  color: #fff;
  border: 1px solid rgba(255, 255, 255, 0.19);
  border-radius: 0.5rem;
  padding: 1rem 1.25rem 1.1rem 1.25rem;
  width: 22rem;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
  pointer-events: auto;
`,R9=C.span`
  position: absolute;
  display: inline-flex;
  width: 1.25rem;
  height: 1.25rem;
  color: var(--main-500, #ff830a);
  pointer-events: none;
`,$9=C.div`
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 0.5rem;
  margin-bottom: 0.5rem;
`,L9=C.div`
  display: flex;
  align-items: center;
  gap: 0.5rem;
`,X0=C.h2`
  font-size: 1.05rem;
  font-weight: 600;
  color: #fff;
  margin: 0;
  line-height: 1.2;
`,q0=C.p`
  font-size: 0.85rem;
  line-height: 1.5;
  color: rgba(255, 255, 255, 0.7);
  margin: 0;
`;C.span`
  display: inline-flex;
  width: 1.25rem;
  height: 1.25rem;
  color: var(--main-500, #ff830a);
  flex-shrink: 0;
`;const N9=C.span`
  display: inline-flex;
  width: 1.4rem;
  height: 1.4rem;
  color: rgba(255, 255, 255, 0.85);
  flex-shrink: 0;
`,_9=C.div`
  position: absolute;
  top: 1.5rem;
  right: 1.5rem;
  font-size: 0.75rem;
  color: rgba(255, 255, 255, 0.6);
  letter-spacing: 0.15em;
  text-transform: uppercase;
  pointer-events: none;
`,F9=C.div`
  position: absolute;
  inset: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  pointer-events: none;

  > div {
    pointer-events: auto;
    background: linear-gradient(
        0deg,
        rgba(var(--rgb-color, 255, 131, 10), 0.09) 0%,
        rgba(var(--rgb-color, 255, 131, 10), 0.09) 100%
      ),
      rgba(0, 0, 0, 0.59);
    border: 1px solid var(--main-500, #ff830a);
    border-radius: 0.75rem;
    padding: 1.5rem 1.75rem;
    width: 28rem;
    color: #fff;
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.6);
  }
`,z9=C.button`
  width: 100%;
  height: 2.5rem;
  margin-top: 1rem;
  border: 0;
  border-radius: 0.375rem;
  background: var(--main-500, #ff830a);
  color: #fff;
  font-weight: 600;
  cursor: pointer;
  transition: filter 0.2s;

  &:hover {
    filter: brightness(1.1);
  }
`,V9=C.div`
  position: absolute;
  bottom: 2rem;
  left: 50%;
  transform: translateX(-50%);
  font-size: 0.75rem;
  color: rgba(255, 255, 255, 0.6);
  text-transform: uppercase;
  letter-spacing: 0.08em;
  pointer-events: none;

  strong {
    color: var(--main-500, #ff830a);
    font-weight: 600;
  }
`,j9=22,B9=4,U9="https://cdn.santagroup.gg/8e842f94-9bcf-4ed8-819d-4cc1f34f56d6-digitando.mp3";let Gr=null;function H9(e){if(e%B9===0)try{Gr||(Gr=new Audio(U9),Gr.preload="auto",Gr.volume=.15);const t=Gr.cloneNode();t.volume=Gr.volume,t.play().catch(()=>{})}catch{}}function W9(e,t){const[n,r]=v.exports.useState(""),[o,i]=v.exports.useState(!1);v.exports.useEffect(()=>{if(!t){r(e),i(!0);return}if(r(""),i(!1),!e){i(!0);return}let a=0;const l=window.setInterval(()=>{a+=1,r(e.slice(0,a)),H9(a),a>=e.length&&(window.clearInterval(l),i(!0))},j9);return()=>window.clearInterval(l)},[e,t]);const s=v.exports.useCallback(()=>{r(e),i(!0)},[e]);return{revealed:n,done:o,skip:s}}const Z0="__inventory_tutorial_caret__";function G9(){if(typeof document=="undefined"||document.getElementById(Z0))return;const e=document.createElement("style");e.id=Z0,e.textContent="@keyframes inv-tut-caret { 0%, 100% { opacity: 1 } 50% { opacity: 0 } }",document.head.appendChild(e)}const ld=22*16,K9=24,Y9=338,J0=20,Mt=6;function Q9(e){if(typeof e!="string")return null;let t=e.trim().replace(/^#/,"");if(t.length===3&&(t=t.split("").map(r=>r+r).join("")),t.length!==6)return null;const n=parseInt(t,16);return Number.isNaN(n)?null:`${n>>16&255}, ${n>>8&255}, ${n&255}`}function X9(e){if(!e)return null;const t=document.querySelector(e);if(!t)return null;const n=t.getBoundingClientRect();return{top:n.top,left:n.left,width:n.width,height:n.height}}function q9(e,t){const n=window.innerWidth,r=window.innerHeight,o=t==="auto"?"right":t;let i=0;const s=e.top+e.height/2;let a=!1;o==="left"?(i=e.left-Y9-J0,a=!1):(i=e.left+e.width+J0,a=!0);let l=e.left,c=e.top+e.height+K9;return l+ld>n-12&&(l=n-ld-12),l<12&&(l=12),c<12&&(c=12),c>r-180&&(c=r-180),{tipLeft:l,tipTop:c,arrowLeft:i,arrowTop:s,arrowFlipped:a}}const Z9=()=>f("svg",{xmlns:"http://www.w3.org/2000/svg",width:"20",height:"20",viewBox:"0 0 20 20",fill:"none",children:f("path",{d:"M15.4942 13.171C15.8647 12.8981 15.9439 12.3764 15.671 12.0058C15.459 11.718 15.247 11.4444 15.061 11.2061C14.6897 10.7304 14.1786 10.0932 13.6233 9.45375C13.0716 8.81833 12.4599 8.16142 11.8889 7.65684C11.6043 7.40539 11.3101 7.17415 11.0233 7.00125C10.7594 6.84213 10.3967 6.66675 9.99996 6.66675C9.60321 6.66675 9.24046 6.84213 8.97654 7.00125C8.68971 7.17415 8.39562 7.40539 8.11104 7.65684C7.53997 8.16142 6.92827 8.81833 6.37657 9.45375C5.82127 10.0932 5.31017 10.7304 4.93891 11.2061C4.75293 11.4444 4.54089 11.718 4.3289 12.0058C4.05597 12.3764 4.13513 12.8981 4.50571 13.171C4.65467 13.2807 4.82806 13.3336 4.99989 13.3334H9.99996H15C15.1718 13.3336 15.3452 13.2807 15.4942 13.171Z",fill:"currentColor"})}),J9=()=>P("svg",{xmlns:"http://www.w3.org/2000/svg",width:"21",height:"21",viewBox:"0 0 21 21",fill:"none",children:[f("path",{"fill-rule":"evenodd","clip-rule":"evenodd",d:"M5.19046 1.32867C5.54397 1.65816 5.56344 2.21183 5.23396 2.56534C4.41797 3.44082 3.88453 4.48247 3.70827 5.60453C3.63329 6.08192 3.1855 6.40814 2.7081 6.33315C2.23071 6.25817 1.90449 5.81038 1.97948 5.33298C2.21524 3.83202 2.92407 2.47696 3.95379 1.37217C4.28328 1.01866 4.83695 0.999181 5.19046 1.32867Z",fill:"white"}),f("path",{"fill-rule":"evenodd","clip-rule":"evenodd",d:"M11.1562 1.35359C11.1562 1.20443 11.0321 1.08507 10.8832 1.09343C10.3595 1.1228 9.84419 1.17404 9.33914 1.23634C6.88977 1.53855 4.9968 3.57256 4.80634 5.975C4.69078 7.43245 4.59375 8.94224 4.59375 10.486C4.59375 12.0298 4.69078 13.5396 4.80634 14.9971C4.99681 17.3995 6.88986 19.4334 9.33922 19.7357C10.1402 19.8345 10.9673 19.9056 11.8125 19.9056C12.6576 19.9056 13.4848 19.8344 14.2858 19.7357C16.7352 19.4334 18.628 17.3995 18.8186 14.9971C18.9342 13.5396 19.0312 12.0298 19.0312 10.486C19.0312 8.94224 18.9342 7.43243 18.8186 5.975C18.628 3.57258 16.7352 1.53855 14.2858 1.23634C13.7808 1.17404 13.2655 1.1228 12.7418 1.09343C12.5929 1.08507 12.4688 1.20443 12.4688 1.3536V4.36412C12.4688 4.49625 12.5681 4.60451 12.6952 4.64056C12.7417 4.65375 12.7887 4.66981 12.836 4.68939C13.2112 4.84503 13.5093 5.14354 13.6647 5.51927C13.7366 5.69321 13.7608 5.86437 13.7714 6.02002C13.7812 6.16489 13.7812 6.33738 13.7812 6.52512V7.4395C13.7812 7.62726 13.7812 7.79974 13.7714 7.9446C13.7608 8.10026 13.7366 8.27142 13.6647 8.44536C13.5093 8.82105 13.2112 9.1196 12.836 9.27527C12.7887 9.29478 12.7417 9.31088 12.6952 9.32409C12.5681 9.36014 12.4688 9.46838 12.4688 9.6005V10.4872C12.4688 10.8502 12.1749 11.1444 11.8125 11.1444C11.4501 11.1444 11.1562 10.8502 11.1562 10.4872V9.6005C11.1562 9.46838 11.0569 9.36014 10.9298 9.32409C10.8833 9.31088 10.8363 9.29478 10.789 9.27527C10.4138 9.1196 10.1157 8.82105 9.9603 8.44536C9.88837 8.27142 9.86423 8.10026 9.85364 7.9446C9.84375 7.79974 9.84375 7.62725 9.84375 7.4395V6.52513C9.84375 6.33738 9.84375 6.16489 9.85364 6.02002C9.86423 5.86437 9.88837 5.69321 9.9603 5.51927C10.1157 5.14354 10.4138 4.84503 10.789 4.68939C10.8363 4.66981 10.8833 4.65375 10.9298 4.64055C11.0569 4.60451 11.1562 4.49625 11.1562 4.36412V1.35359ZM11.1702 6.03987C11.1723 6.0263 11.1765 6.01311 11.183 6.00105C11.2031 5.96425 11.2333 5.93398 11.2701 5.91388C11.2822 5.90726 11.2954 5.90304 11.3089 5.90095C11.3233 5.89876 11.3455 5.89608 11.3784 5.89384C11.4729 5.88738 11.5997 5.88702 11.8125 5.88702C12.0253 5.88702 12.1521 5.88738 12.2466 5.89384C12.2795 5.89608 12.3017 5.89876 12.3161 5.90096C12.3296 5.90305 12.3428 5.90726 12.3549 5.91387C12.3917 5.93398 12.4219 5.96425 12.442 6.00105C12.4485 6.01311 12.4527 6.0263 12.4548 6.03987C12.457 6.05421 12.4597 6.07651 12.4619 6.10949C12.4684 6.20413 12.4688 6.33107 12.4688 6.5442V7.42043C12.4688 7.63356 12.4684 7.76049 12.4619 7.85513C12.4597 7.8881 12.457 7.91041 12.4548 7.92475C12.4527 7.93833 12.4485 7.95152 12.442 7.96358C12.4219 8.00038 12.3917 8.03065 12.3549 8.05076C12.3428 8.05736 12.3296 8.06158 12.3161 8.06367C12.3017 8.06587 12.2795 8.06855 12.2466 8.0708C12.1521 8.07725 12.0253 8.0776 11.8125 8.0776C11.5997 8.0776 11.4729 8.07725 11.3784 8.0708C11.3455 8.06855 11.3233 8.06587 11.3089 8.06367C11.2954 8.06158 11.2822 8.05736 11.2701 8.05076C11.2333 8.03064 11.2031 8.00037 11.183 7.96357C11.1765 7.95151 11.1723 7.93834 11.1702 7.92476C11.168 7.91042 11.1653 7.88811 11.1631 7.85513C11.1566 7.76049 11.1562 7.63356 11.1562 7.42043V6.5442C11.1562 6.33107 11.1566 6.20413 11.1631 6.10949C11.1653 6.07651 11.168 6.05421 11.1702 6.03987Z",fill:"white"})]}),eI=()=>P("svg",{xmlns:"http://www.w3.org/2000/svg",width:"338",height:"15",viewBox:"0 0 338 15",fill:"none",children:[f("path",{d:"M0.292908 6.65691C-0.0976257 7.04743 -0.0976257 7.6806 0.292908 8.07112L6.65686 14.4351C7.04739 14.8256 7.68054 14.8256 8.07108 14.4351C8.46158 14.0446 8.46158 13.4114 8.07108 13.0209L2.41422 7.36401L8.07108 1.70716C8.46158 1.31664 8.46158 0.68347 8.07108 0.292946C7.68054 -0.0975785 7.04739 -0.0975785 6.65686 0.292946L0.292908 6.65691ZM338 7.36401V6.36401L1 6.36401V7.36401V8.36401L338 8.36401V7.36401Z",fill:"url(#tutorialInvArrowGradient)"}),f("defs",{children:P("linearGradient",{id:"tutorialInvArrowGradient",x1:"1",y1:"6.86401",x2:"338",y2:"6.86401",gradientUnits:"userSpaceOnUse",children:[f("stop",{stopColor:"currentColor"}),f("stop",{offset:"1",stopColor:"currentColor",stopOpacity:"0"})]})})]});function tI(){var I,O,L,_,re,J,se;const{isOpen:e,currentStep:t,steps:n,step:r,next:o,close:i,markEngaged:s,getEngagedCount:a}=Q5(),{secondaryInventory:l}=Et(),c=ll(),{theme:u}=Ay(),d=(L=(O=(I=u==null?void 0:u.colors)==null?void 0:I.main)==null?void 0:O[500])!=null?L:"#ff830a",p=(_=Q9(d))!=null?_:"255, 131, 10",[y,w]=v.exports.useState(null),x=v.exports.useRef(!1),b=v.exports.useRef(l==null?void 0:l.type);v.exports.useEffect(()=>{b.current=l==null?void 0:l.type},[l==null?void 0:l.type]),v.exports.useEffect(()=>{e&&(x.current=!1)},[e]),v.exports.useEffect(()=>G9(),[]);const g=W9((re=r==null?void 0:r.content)!=null?re:"",e);v.exports.useEffect(()=>{if(!e||g.done)return;const j=Y=>{(Y.code==="Space"||Y.code==="Enter")&&(Y.preventDefault(),g.skip())};return window.addEventListener("keydown",j),()=>window.removeEventListener("keydown",j)},[e,g.done,g.skip]);const h=v.exports.useCallback(j=>{if(x.current)return;x.current=!0;const Y=a(),z=n.filter(W=>W.advanceOnClick||W.advanceOnDrop).length,ee=Math.min(S9,z),$=Y>=ee,B={completed:j,lastStep:t,totalSteps:n.length,secondaryInventoryType:b.current,engagedCount:Y,threshold:ee},G=$?"tutorialInventory:finished":"tutorialInventory:skipped";try{console.info("[InventoryTutorial] "+G+" \u2014 "+JSON.stringify(B)),Oe(G,B)}catch{}i()},[t,n,i,a]),m=v.exports.useCallback(()=>{t>=n.length-1?h(!0):o()},[t,n.length,o,h]);if(v.exports.useEffect(()=>{if(!e||!(r!=null&&r.target)){w(null);return}const j=()=>w(X9(r.target));j();const Y=window.setInterval(j,200);window.addEventListener("resize",j);const z=new MutationObserver(j);return z.observe(document.body,{childList:!0,subtree:!0}),()=>{window.clearInterval(Y),window.removeEventListener("resize",j),z.disconnect()}},[e,r==null?void 0:r.target,t]),v.exports.useEffect(()=>{!e||!(r!=null&&r.advanceOnPath)||c.pathname===r.advanceOnPath&&m()},[e,c.pathname,r==null?void 0:r.advanceOnPath,m]),v.exports.useEffect(()=>{if(!e||!(r!=null&&r.advanceOnClick)||!r.target)return;let j=null,Y=null;const z=()=>{const ee=document.querySelector(r.target);return!ee||ee===j?!1:(j&&Y&&j.removeEventListener("click",Y,!0),j=ee,Y=()=>{s(t),m()},j.addEventListener("click",Y,!0),!0)};if(!z()){const ee=new MutationObserver(()=>{z()&&ee.disconnect()});return ee.observe(document.body,{childList:!0,subtree:!0}),()=>{ee.disconnect(),j&&Y&&j.removeEventListener("click",Y,!0)}}return()=>{j&&Y&&j.removeEventListener("click",Y,!0)}},[e,r==null?void 0:r.advanceOnClick,r==null?void 0:r.target,t,m,s]),v.exports.useEffect(()=>{if(!e||!(r!=null&&r.advanceOnAnyClick))return;let j=!1,Y=!1;const z=window.setTimeout(()=>{j=!0},150),ee=()=>{!j||Y||(Y=!0,m())},$=["mousedown","click","pointerdown"];for(const B of $)window.addEventListener(B,ee,!0),document.addEventListener(B,ee,!0);return()=>{window.clearTimeout(z);for(const B of $)window.removeEventListener(B,ee,!0),document.removeEventListener(B,ee,!0)}},[e,r==null?void 0:r.advanceOnAnyClick,t,m]),v.exports.useEffect(()=>{var Y,z;if(!e||!(r!=null&&r.advanceOnDrop))return;console.info("[InventoryTutorial] advanceOnDrop armed step="+t+" from="+JSON.stringify((Y=r.advanceOnDropFrom)!=null?Y:null)+" to="+JSON.stringify((z=r.advanceOnDropTo)!=null?z:null));const j=ee=>{var F,V,X;const $=ee.detail;if(!$||!$.from||!$.to){console.info("[InventoryTutorial] drop received but detail incomplete");return}const{from:B,to:G}=$;console.info("[InventoryTutorial] drop received from="+JSON.stringify({type:B.type,slot:(F=B.item)==null?void 0:F.slot})+" to="+JSON.stringify({type:G.type,slot:G.slot}));const W=r.advanceOnDropFrom;if(W){if(W.fromType&&B.type!==W.fromType){console.info("[InventoryTutorial] drop rejected \u2014 fromType mismatch ("+B.type+" vs "+W.fromType+")");return}if(W.fromSlot!==void 0&&((V=B.item)==null?void 0:V.slot)!==W.fromSlot){console.info("[InventoryTutorial] drop rejected \u2014 fromSlot mismatch ("+((X=B.item)==null?void 0:X.slot)+" vs "+W.fromSlot+")");return}}const R=r.advanceOnDropTo;if(R){if(R.toType&&G.type!==R.toType){console.info("[InventoryTutorial] drop rejected \u2014 toType mismatch ("+G.type+" vs "+R.toType+")");return}if(R.toSlot!==void 0&&G.slot!==R.toSlot){console.info("[InventoryTutorial] drop rejected \u2014 toSlot mismatch ("+G.slot+" vs "+R.toSlot+")");return}}console.info("[InventoryTutorial] drop accepted \u2014 markEngaged + advance"),s(t),m()};return window.addEventListener("inventory:drop",j),()=>window.removeEventListener("inventory:drop",j)},[e,r==null?void 0:r.advanceOnDrop,r==null?void 0:r.advanceOnDropFrom,r==null?void 0:r.advanceOnDropTo,t,m,s]),v.exports.useEffect(()=>{if(!e)return;const j=Y=>{Y.key==="Escape"&&(r==null?void 0:r.closeOnEscape)&&(Y.preventDefault(),Y.stopPropagation(),h(!0))};return window.addEventListener("keydown",j,!0),()=>window.removeEventListener("keydown",j,!0)},[e,r==null?void 0:r.closeOnEscape,h]),v.exports.useEffect(()=>{if(!e)return;const j=Y=>{(Y.button===3||Y.button===4)&&(Y.preventDefault(),Y.stopPropagation(),Y.stopImmediatePropagation())};return window.addEventListener("mousedown",j,!0),window.addEventListener("mouseup",j,!0),window.addEventListener("auxclick",j,!0),()=>{window.removeEventListener("mousedown",j,!0),window.removeEventListener("mouseup",j,!0),window.removeEventListener("auxclick",j,!0)}},[e]),!e||!r)return null;const S=!!(r.target&&y),E=(J=r.placement)!=null?J:"right",T=S?q9(y,E):null;return P(P9,{style:{"--main-500":d,"--rgb-color":p},children:[S?P(pe,{children:[f(Is,{style:{top:0,left:0,right:0,height:Math.max(0,y.top-Mt)}}),f(Is,{style:{top:y.top+y.height+Mt,left:0,right:0,bottom:0}}),f(Is,{style:{top:Math.max(0,y.top-Mt),height:y.height+Mt*2,left:0,width:Math.max(0,y.left-Mt)}}),f(Is,{style:{top:Math.max(0,y.top-Mt),height:y.height+Mt*2,left:y.left+y.width+Mt,right:0}}),f(I9,{style:{top:y.top-Mt,left:y.left-Mt,width:y.width+Mt*2,height:y.height+Mt*2}}),T&&f(D9,{$flipped:T.arrowFlipped,style:{left:T.arrowLeft,top:T.arrowTop},children:f(eI,{})}),T&&(r.title||r.content)&&f(R9,{style:{top:T.tipTop-12,left:T.tipLeft+20},children:f(Z9,{})}),T&&(r.title||r.content)&&P(M9,{style:{top:T.tipTop,left:T.tipLeft,width:ld},children:[P($9,{children:[f(L9,{children:r.title&&f(X0,{children:r.title})}),f(N9,{children:f(J9,{})})]}),r.content&&P(q0,{children:[g.revealed,!g.done&&f("span",{style:{animation:"inv-tut-caret 1s infinite"},"aria-hidden":!0,children:"\u258D"})]})]})]}):P(pe,{children:[f(T9,{}),(r.title||r.content)&&f(F9,{children:P("div",{children:[r.title&&f(X0,{style:{color:"var(--main-500, #ff830a)",marginBottom:"0.75rem",fontSize:"1.2rem"},children:r.title}),r.content&&P(q0,{children:[g.revealed,!g.done&&f("span",{style:{animation:"inv-tut-caret 1s infinite"},"aria-hidden":!0,children:"\u258D"})]}),!r.advanceOnClick&&!r.advanceOnAnyClick&&!r.advanceOnDrop&&!r.advanceOnPath&&!r.closeOnEscape&&f(z9,{onClick:()=>{if(!g.done){g.skip();return}m()},children:(se=r.continueLabel)!=null?se:"Pr\xF3ximo"})]})})]}),r.closeOnEscape&&P(V9,{children:["Pressione ",f("strong",{children:"ESC"})," para fechar"]}),n.length>1&&P(_9,{children:[t+1," / ",n.length]})]})}const eg=[{target:'[data-tutorial-target="main-slot-6"]',placement:"right",title:"Arraste para adquirir",content:"Para mover os itens do seu invent\xE1rio, segure o clique esquerdo do mouse para arrastar e usar o item.",advanceOnDrop:!0,advanceOnDropFrom:{fromType:"main",fromSlot:6},advanceOnDropTo:{toType:"chest"}}],nI=()=>{const{open:e,close:t,next:n,prev:r,goTo:o}=Q5();return v.exports.useEffect(()=>{const i={start:(a=eg)=>e(a),startChest:()=>e(eg),next:()=>n(),prev:()=>r(),goTo:a=>o(a),close:()=>t()};window.tutorialDebug=i;const s=a=>{if(!a.ctrlKey||!a.shiftKey)return;const l=a.key.toLowerCase();l==="t"?(a.preventDefault(),i.start()):l==="n"?(a.preventDefault(),i.next()):l==="x"&&(a.preventDefault(),i.close())};return window.addEventListener("keydown",s),()=>{window.removeEventListener("keydown",s),delete window.tutorialDebug}},[e,t,n,r,o]),null};function rI({children:e}){const t=dP();return P(w9,{children:[f(pP,{}),f(b9,{children:P(C9,{hiddenHeader:t===null,children:[f(oP,{}),f(f5,{children:t}),e,f(G7,{})]})}),f(tI,{}),f(nI,{}),f(Uk,{})]})}function oI(){return P(b4,{children:[f(Xe,{path:"/trade/seller",element:f(Yo,{roleOverride:"seller"})}),f(Xe,{path:"/trade/buyer",element:f(Yo,{roleOverride:"buyer"})}),f(Xe,{path:"/trade/:role",element:f(Yo,{})}),f(Xe,{path:"/trade-seller",element:f(Yo,{roleOverride:"seller"})}),f(Xe,{path:"/trade-buyer",element:f(Yo,{roleOverride:"buyer"})}),f(Xe,{path:"/chest-permission/member",element:f(Qo,{modeOverride:"member"})}),f(Xe,{path:"/chest-permission/role",element:f(Qo,{modeOverride:"role"})}),f(Xe,{path:"/chest-permission/:mode",element:f(Qo,{})}),f(Xe,{path:"/bau-permissao/membro",element:f(Qo,{modeOverride:"member"})}),f(Xe,{path:"/bau-permissao/cargo",element:f(Qo,{modeOverride:"role"})}),f(Xe,{path:"/faction-arsenal",element:f(Es,{})}),f(Xe,{path:"/faction-arsenal/setup",element:f(Es,{stateOverride:"unset"})}),f(Xe,{path:"/faction-arsenal/config",element:f(Es,{stateOverride:"configured"})}),f(Xe,{path:"/arsenal-faccao",element:f(Es,{})}),f(Xe,{path:"/:type",element:f(rI,{children:f(x9,{})})}),f(Xe,{path:"/",element:f(x4,{to:"/main",replace:!0})})]})}const iI=C.div`
  position: absolute;
  top: -0.5rem;
  right: -0.5rem;
  z-index: 10;
`,sI=C.div`
  background: var(--red-500, #EF4444);
  border-radius: 0.3rem;
  color: white;
  color: #FFF;
  text-align: center;
  font-family: Poppins;
  font-size: 1rem;
  font-style: normal;
  font-weight: 500;
  line-height: normal;  
  font-weight: 600;
  display: flex;
  padding: 0 0.4rem;
  justify-content: center;
  align-items: center;
  gap: 1rem;
`;function aI({count:e,isVisible:t}){return!t||e<=0?f(pe,{}):f(iI,{children:f(sI,{children:e>99?"99+":e})})}const lI=C(Ji)`
  background: rgba(0, 0, 0, 0.2);
  color: rgba(255, 255, 255, 0.8);
  font-weight: 500;
  height: 1.5rem;
  border-radius: 2px;
  padding: 0 0.5rem;

  font-size: 0.8rem;
  font-weight: 700;

  position: absolute;
  right: 0.25rem;
  top: 0.25rem;
  
  z-index: 3 !important;

  svg {
    height: 0.8rem;
    width: 0.8rem;
    margin-right: 0.35rem;
  }
`;function cI({price:e,isPremium:t}){if(e===void 0)return f(pe,{});const{currentAmount:n}=Et();return P(lI,{isPremium:t,children:[f(v5,{isPremium:t}),Bf(e*(n===0?1:n),2)]})}const uI=C(Ji)`
  position: absolute;
  left: 0.5rem;
  top: 0.5rem;
`;function dI({weight:e}){return e!==void 0&&e>0?f(uI,{children:uk(e,1)}):f(pe,{})}function Zf({item:e,inventoryType:t}){var a;if(!Nt(e)||e.amount<=0&&t!=="shop")return f(pe,{});const n=t==="shop",r=t==="hotbar"||t==="shop",o=t==="shop"&&e.price!==0,i=t==="notify"&&e.mode!==void 0,s=e.index==="dollars";return P(pe,{children:[i?f(zk,{mode:e.mode}):null,o?f(kk,{stock:e.stock}):null,o?f(cI,{price:e.price,isPremium:e.premium}):null,!s&&!r?f(dI,{weight:e.weight}):null,n?null:f(Ik,{amount:e.amount,atRight:i,isMoney:e.index==="dollars"}),f(Rk,{index:e.key,fallbackKey:e.index,isBig:t==="shop",imageSrc:e.image}),f(jk,{inventoryType:t,children:h5(e.key,e.name)}),t!=="notify"?f(Dk,{days:e.days,durability:(a=e.durability)!=null?a:e.Durability,inventoryType:t}):null]})}const fI=({amount:e,item:t,mode:n,name:r})=>f(Hf,{type:"notify",children:f(Zf,{item:{key:t,index:t,name:r,amount:e,desc:"",max:1,weight:0,mode:n,slot:0,days:0,economy:0},inventoryType:"notify"})});let hI={data:""},pI=e=>typeof window=="object"?((e?e.querySelector("#_goober"):window._goober)||Object.assign((e||document.head).appendChild(document.createElement("style")),{innerHTML:" ",id:"_goober"})).firstChild:e||hI,mI=/(?:([\u0080-\uFFFF\w-%@]+) *:? *([^{;]+?);|([^;}{]*?) *{)|(}\s*)/g,gI=/\/\*[^]*?\*\/|  +/g,tg=/\n+/g,Ln=(e,t)=>{let n="",r="",o="";for(let i in e){let s=e[i];i[0]=="@"?i[1]=="i"?n=i+" "+s+";":r+=i[1]=="f"?Ln(s,i):i+"{"+Ln(s,i[1]=="k"?"":t)+"}":typeof s=="object"?r+=Ln(s,t?t.replace(/([^,])+/g,a=>i.replace(/([^,]*:\S+\([^)]*\))|([^,])+/g,l=>/&/.test(l)?l.replace(/&/g,a):a?a+" "+l:l)):i):s!=null&&(i=/^--/.test(i)?i:i.replace(/[A-Z]/g,"-$&").toLowerCase(),o+=Ln.p?Ln.p(i,s):i+":"+s+";")}return n+(t&&o?t+"{"+o+"}":o)+r},un={},X5=e=>{if(typeof e=="object"){let t="";for(let n in e)t+=n+X5(e[n]);return t}return e},yI=(e,t,n,r,o)=>{let i=X5(e),s=un[i]||(un[i]=(l=>{let c=0,u=11;for(;c<l.length;)u=101*u+l.charCodeAt(c++)>>>0;return"go"+u})(i));if(!un[s]){let l=i!==e?e:(c=>{let u,d,p=[{}];for(;u=mI.exec(c.replace(gI,""));)u[4]?p.shift():u[3]?(d=u[3].replace(tg," ").trim(),p.unshift(p[0][d]=p[0][d]||{})):p[0][u[1]]=u[2].replace(tg," ").trim();return p[0]})(e);un[s]=Ln(o?{["@keyframes "+s]:l}:l,n?"":"."+s)}let a=n&&un.g?un.g:null;return n&&(un.g=un[s]),((l,c,u,d)=>{d?c.data=c.data.replace(d,l):c.data.indexOf(l)===-1&&(c.data=u?l+c.data:c.data+l)})(un[s],t,r,a),s},vI=(e,t,n)=>e.reduce((r,o,i)=>{let s=t[i];if(s&&s.call){let a=s(n),l=a&&a.props&&a.props.className||/^go/.test(a)&&a;s=l?"."+l:a&&typeof a=="object"?a.props?"":Ln(a,""):a===!1?"":a}return r+o+(s==null?"":s)},"");function El(e){let t=this||{},n=e.call?e(t.p):e;return yI(n.unshift?n.raw?vI(n,[].slice.call(arguments,1),t.p):n.reduce((r,o)=>Object.assign(r,o&&o.call?o(t.p):o),{}):n,pI(t.target),t.g,t.o,t.k)}let q5,cd,ud;El.bind({g:1});let kn=El.bind({k:1});function xI(e,t,n,r){Ln.p=t,q5=e,cd=n,ud=r}function ar(e,t){let n=this||{};return function(){let r=arguments;function o(i,s){let a=Object.assign({},i),l=a.className||o.className;n.p=Object.assign({theme:cd&&cd()},a),n.o=/ *go\d+/.test(l),a.className=El.apply(n,r)+(l?" "+l:""),t&&(a.ref=s);let c=e;return e[0]&&(c=a.as||e,delete a.as),ud&&c[0]&&ud(a),q5(c,a)}return t?t(o):o}}var wI=e=>typeof e=="function",Da=(e,t)=>wI(e)?e(t):e,bI=(()=>{let e=0;return()=>(++e).toString()})(),CI=(()=>{let e;return()=>{if(e===void 0&&typeof window<"u"){let t=matchMedia("(prefers-reduced-motion: reduce)");e=!t||t.matches}return e}})(),SI=20,Jf="default",Z5=(e,t)=>{let{toastLimit:n}=e.settings;switch(t.type){case 0:return{...e,toasts:[t.toast,...e.toasts].slice(0,n)};case 1:return{...e,toasts:e.toasts.map(s=>s.id===t.toast.id?{...s,...t.toast}:s)};case 2:let{toast:r}=t;return Z5(e,{type:e.toasts.find(s=>s.id===r.id)?1:0,toast:r});case 3:let{toastId:o}=t;return{...e,toasts:e.toasts.map(s=>s.id===o||o===void 0?{...s,dismissed:!0,visible:!1}:s)};case 4:return t.toastId===void 0?{...e,toasts:[]}:{...e,toasts:e.toasts.filter(s=>s.id!==t.toastId)};case 5:return{...e,pausedAt:t.time};case 6:let i=t.time-(e.pausedAt||0);return{...e,pausedAt:void 0,toasts:e.toasts.map(s=>({...s,pauseDuration:s.pauseDuration+i}))}}},Ks=[],J5={toasts:[],pausedAt:void 0,settings:{toastLimit:SI}},rn={},e2=(e,t=Jf)=>{rn[t]=Z5(rn[t]||J5,e),Ks.forEach(([n,r])=>{n===t&&r(rn[t])})},t2=e=>Object.keys(rn).forEach(t=>e2(e,t)),kI=e=>Object.keys(rn).find(t=>rn[t].toasts.some(n=>n.id===e)),Il=(e=Jf)=>t=>{e2(t,e)},PI={blank:4e3,error:4e3,success:2e3,loading:1/0,custom:4e3},TI=(e={},t=Jf)=>{let[n,r]=v.exports.useState(rn[t]||J5),o=v.exports.useRef(rn[t]);v.exports.useEffect(()=>(o.current!==rn[t]&&r(rn[t]),Ks.push([t,r]),()=>{let s=Ks.findIndex(([a])=>a===t);s>-1&&Ks.splice(s,1)}),[t]);let i=n.toasts.map(s=>{var a,l,c;return{...e,...e[s.type],...s,removeDelay:s.removeDelay||((a=e[s.type])==null?void 0:a.removeDelay)||(e==null?void 0:e.removeDelay),duration:s.duration||((l=e[s.type])==null?void 0:l.duration)||(e==null?void 0:e.duration)||PI[s.type],style:{...e.style,...(c=e[s.type])==null?void 0:c.style,...s.style}}});return{...n,toasts:i}},EI=(e,t="blank",n)=>({createdAt:Date.now(),visible:!0,dismissed:!1,type:t,ariaProps:{role:"status","aria-live":"polite"},message:e,pauseDuration:0,...n,id:(n==null?void 0:n.id)||bI()}),ts=e=>(t,n)=>{let r=EI(t,e,n);return Il(r.toasterId||kI(r.id))({type:2,toast:r}),r.id},He=(e,t)=>ts("blank")(e,t);He.error=ts("error");He.success=ts("success");He.loading=ts("loading");He.custom=ts("custom");He.dismiss=(e,t)=>{let n={type:3,toastId:e};t?Il(t)(n):t2(n)};He.dismissAll=e=>He.dismiss(void 0,e);He.remove=(e,t)=>{let n={type:4,toastId:e};t?Il(t)(n):t2(n)};He.removeAll=e=>He.remove(void 0,e);He.promise=(e,t,n)=>{let r=He.loading(t.loading,{...n,...n==null?void 0:n.loading});return typeof e=="function"&&(e=e()),e.then(o=>{let i=t.success?Da(t.success,o):void 0;return i?He.success(i,{id:r,...n,...n==null?void 0:n.success}):He.dismiss(r),o}).catch(o=>{let i=t.error?Da(t.error,o):void 0;i?He.error(i,{id:r,...n,...n==null?void 0:n.error}):He.dismiss(r)}),e};var II=1e3,OI=(e,t="default")=>{let{toasts:n,pausedAt:r}=TI(e,t),o=v.exports.useRef(new Map).current,i=v.exports.useCallback((d,p=II)=>{if(o.has(d))return;let y=setTimeout(()=>{o.delete(d),s({type:4,toastId:d})},p);o.set(d,y)},[]);v.exports.useEffect(()=>{if(r)return;let d=Date.now(),p=n.map(y=>{if(y.duration===1/0)return;let w=(y.duration||0)+y.pauseDuration-(d-y.createdAt);if(w<0){y.visible&&He.dismiss(y.id);return}return setTimeout(()=>He.dismiss(y.id,t),w)});return()=>{p.forEach(y=>y&&clearTimeout(y))}},[n,r,t]);let s=v.exports.useCallback(Il(t),[t]),a=v.exports.useCallback(()=>{s({type:5,time:Date.now()})},[s]),l=v.exports.useCallback((d,p)=>{s({type:1,toast:{id:d,height:p}})},[s]),c=v.exports.useCallback(()=>{r&&s({type:6,time:Date.now()})},[r,s]),u=v.exports.useCallback((d,p)=>{let{reverseOrder:y=!1,gutter:w=8,defaultPosition:x}=p||{},b=n.filter(m=>(m.position||x)===(d.position||x)&&m.height),g=b.findIndex(m=>m.id===d.id),h=b.filter((m,S)=>S<g&&m.visible).length;return b.filter(m=>m.visible).slice(...y?[h+1]:[0,h]).reduce((m,S)=>m+(S.height||0)+w,0)},[n]);return v.exports.useEffect(()=>{n.forEach(d=>{if(d.dismissed)i(d.id,d.removeDelay);else{let p=o.get(d.id);p&&(clearTimeout(p),o.delete(d.id))}})},[n,i]),{toasts:n,handlers:{updateHeight:l,startPause:a,endPause:c,calculateOffset:u}}},AI=kn`
from {
  transform: scale(0) rotate(45deg);
	opacity: 0;
}
to {
 transform: scale(1) rotate(45deg);
  opacity: 1;
}`,DI=kn`
from {
  transform: scale(0);
  opacity: 0;
}
to {
  transform: scale(1);
  opacity: 1;
}`,MI=kn`
from {
  transform: scale(0) rotate(90deg);
	opacity: 0;
}
to {
  transform: scale(1) rotate(90deg);
	opacity: 1;
}`,RI=ar("div")`
  width: 20px;
  opacity: 0;
  height: 20px;
  border-radius: 10px;
  background: ${e=>e.primary||"#ff4b4b"};
  position: relative;
  transform: rotate(45deg);

  animation: ${AI} 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275)
    forwards;
  animation-delay: 100ms;

  &:after,
  &:before {
    content: '';
    animation: ${DI} 0.15s ease-out forwards;
    animation-delay: 150ms;
    position: absolute;
    border-radius: 3px;
    opacity: 0;
    background: ${e=>e.secondary||"#fff"};
    bottom: 9px;
    left: 4px;
    height: 2px;
    width: 12px;
  }

  &:before {
    animation: ${MI} 0.15s ease-out forwards;
    animation-delay: 180ms;
    transform: rotate(90deg);
  }
`,$I=kn`
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
`,LI=ar("div")`
  width: 12px;
  height: 12px;
  box-sizing: border-box;
  border: 2px solid;
  border-radius: 100%;
  border-color: ${e=>e.secondary||"#e0e0e0"};
  border-right-color: ${e=>e.primary||"#616161"};
  animation: ${$I} 1s linear infinite;
`,NI=kn`
from {
  transform: scale(0) rotate(45deg);
	opacity: 0;
}
to {
  transform: scale(1) rotate(45deg);
	opacity: 1;
}`,_I=kn`
0% {
	height: 0;
	width: 0;
	opacity: 0;
}
40% {
  height: 0;
	width: 6px;
	opacity: 1;
}
100% {
  opacity: 1;
  height: 10px;
}`,FI=ar("div")`
  width: 20px;
  opacity: 0;
  height: 20px;
  border-radius: 10px;
  background: ${e=>e.primary||"#61d345"};
  position: relative;
  transform: rotate(45deg);

  animation: ${NI} 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275)
    forwards;
  animation-delay: 100ms;
  &:after {
    content: '';
    box-sizing: border-box;
    animation: ${_I} 0.2s ease-out forwards;
    opacity: 0;
    animation-delay: 200ms;
    position: absolute;
    border-right: 2px solid;
    border-bottom: 2px solid;
    border-color: ${e=>e.secondary||"#fff"};
    bottom: 6px;
    left: 6px;
    height: 10px;
    width: 6px;
  }
`,zI=ar("div")`
  position: absolute;
`,VI=ar("div")`
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
  min-width: 20px;
  min-height: 20px;
`,jI=kn`
from {
  transform: scale(0.6);
  opacity: 0.4;
}
to {
  transform: scale(1);
  opacity: 1;
}`,BI=ar("div")`
  position: relative;
  transform: scale(0.6);
  opacity: 0.4;
  min-width: 20px;
  animation: ${jI} 0.3s 0.12s cubic-bezier(0.175, 0.885, 0.32, 1.275)
    forwards;
`,UI=({toast:e})=>{let{icon:t,type:n,iconTheme:r}=e;return t!==void 0?typeof t=="string"?v.exports.createElement(BI,null,t):t:n==="blank"?null:v.exports.createElement(VI,null,v.exports.createElement(LI,{...r}),n!=="loading"&&v.exports.createElement(zI,null,n==="error"?v.exports.createElement(RI,{...r}):v.exports.createElement(FI,{...r})))},HI=e=>`
0% {transform: translate3d(0,${e*-200}%,0) scale(.6); opacity:.5;}
100% {transform: translate3d(0,0,0) scale(1); opacity:1;}
`,WI=e=>`
0% {transform: translate3d(0,0,-1px) scale(1); opacity:1;}
100% {transform: translate3d(0,${e*-150}%,-1px) scale(.6); opacity:0;}
`,GI="0%{opacity:0;} 100%{opacity:1;}",KI="0%{opacity:1;} 100%{opacity:0;}",YI=ar("div")`
  display: flex;
  align-items: center;
  background: #fff;
  color: #363636;
  line-height: 1.3;
  will-change: transform;
  box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1), 0 3px 3px rgba(0, 0, 0, 0.05);
  max-width: 350px;
  pointer-events: auto;
  padding: 8px 10px;
  border-radius: 8px;
`,QI=ar("div")`
  display: flex;
  justify-content: center;
  margin: 4px 10px;
  color: inherit;
  flex: 1 1 auto;
  white-space: pre-line;
`,XI=(e,t)=>{let n=e.includes("top")?1:-1,[r,o]=CI()?[GI,KI]:[HI(n),WI(n)];return{animation:t?`${kn(r)} 0.35s cubic-bezier(.21,1.02,.73,1) forwards`:`${kn(o)} 0.4s forwards cubic-bezier(.06,.71,.55,1)`}},qI=v.exports.memo(({toast:e,position:t,style:n,children:r})=>{let o=e.height?XI(e.position||t||"top-center",e.visible):{opacity:0},i=v.exports.createElement(UI,{toast:e}),s=v.exports.createElement(QI,{...e.ariaProps},Da(e.message,e));return v.exports.createElement(YI,{className:e.className,style:{...o,...n,...e.style}},typeof r=="function"?r({icon:i,message:s}):v.exports.createElement(v.exports.Fragment,null,i,s))});xI(v.exports.createElement);El`
  z-index: 9999;
  > * {
    pointer-events: auto;
  }
`;v.exports.createContext({});const ZI=(()=>{let e;return()=>{if(e===void 0&&typeof window!="undefined"){const t=matchMedia("(prefers-reduced-motion: reduce)");e=!t||t.matches}return e}})(),JI=(e,t)=>{const n=e.includes("top"),r=n?{top:0}:{bottom:0},o=e.includes("center")?{justifyContent:"center"}:e.includes("right")?{justifyContent:"flex-end"}:{};return{left:0,right:0,display:"flex",position:"absolute",transition:ZI()?void 0:"all 230ms cubic-bezier(.21,1.02,.73,1)",transform:`translateX(${t*(n?1:-1)}px)`,...r,...o}},eO=({id:e,className:t,style:n,onHeightUpdate:r,children:o})=>{const i=Ke.useCallback(s=>{if(s){const a=()=>{const l=s.getBoundingClientRect().height;r(e,l)};a(),new MutationObserver(a).observe(s,{subtree:!0,childList:!0,characterData:!0})}},[e,r]);return f("div",{ref:i,className:t,style:n,children:o})},tO=({reverseOrder:e,position:t="top-center",toastOptions:n,gutter:r,children:o,containerStyle:i,containerClassName:s})=>{const{toasts:a,handlers:l}=OI(n);return f("div",{style:{position:"fixed",zIndex:5,top:"1em",left:"1em",right:"1em",bottom:"1em",pointerEvents:"none",...i},className:s,children:a.map(c=>{const u=c.position||t,d=l.calculateOffset(c,{reverseOrder:e,gutter:r,defaultPosition:t}),p=JI(u,d);return f(eO,{id:c.id,onHeightUpdate:l.updateHeight,style:p,children:c.type==="custom"?Da(c.message,c):o?o(c):f(qI,{toast:c,position:u})},c.id)})})},nO=v.exports.createContext(null),rO=({children:e})=>{const t=n=>{He(()=>f(fI,{...n}),{position:"bottom-center",duration:5e3})};return ot("addItemNotify",t),v.exports.useEffect(()=>{pt()&&t({amount:1,item:"no-image",mode:"added",name:"test"}),pt()&&t({amount:1,item:"dollars",mode:"removed",name:"dollars"}),pt()&&t({amount:1,item:"dollars",mode:"updated",name:"dollars"}),pt()&&t({amount:1,item:"dollars",mode:"broke",name:"dollars"})},[]),P(nO.Provider,{value:{},children:[f(tO,{toastOptions:{style:{background:"none",boxShadow:"none",padding:"0",zIndex:100}}}),e]})},n2=v.exports.createContext(null),oO=({children:e})=>{const t=hk();return f(n2.Provider,{value:t,children:e})},iO=()=>{const e=v.exports.useContext(n2);if(!e)throw new Error("useCollectibles must be used within CollectiblesProvider");return e};function sO(){return f(oI,{})}var aO=xb`
    :root {
        --slot-width: 5.45rem;
        --slot-height: 6.65rem;
        --slot-name-height: 1.4rem;
        --slot-gap: 8px;

        --slot-big-width: 7.25rem;
        --slot-big-height: 10rem;
        --slot-big-gap: 10px;

        --inventory-header-height: calc(1.4rem + 3px + (2*10px));
    }

    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        outline: 0;
        
        user-select: none;
        font-variant-numeric: tabular-nums;
    }
    
    body {
        overflow-y: hidden;
        overflow-x: hidden;
        background: ${pt()?"green":"none"};
    }

    body, input, button, * {
        font-family: 'Poppins';
        -webkit-font-smoothing: antialiased;
    }
    
    body, input, button {
        font-size: 1vw;
    }
    
    h1, h2, h3, h4, h5, h6 {
        font-weight: 400;
    }
    
    button {
        cursor: pointer;
    }
    
    :root {
        font-size: 16px;
    }
    
    @media screen and (max-width: 800px), screen and (max-height: 600px) {
        :root {
            font-size: 0.3rem;
        }
    }
    @media screen and (min-width: 800px) and (min-height: 600px) {
        :root {
            font-size: 0.425rem;
        }
    }
    @media screen and (min-width: 1000px) and (min-height: 700px) {
        :root {
            font-size: 0.55rem;
        }
    }
    @media screen and (min-width: 1100px) and (min-height: 700px) {
        :root {
            font-size: 0.6rem;
        }
    }
    @media screen and (min-width: 1300px) and (min-height: 700px) {
        :root {
            font-size: 0.7rem;
        }
    }
    @media screen and (min-width: 1400px) and (min-height: 700px) {
        :root {
            font-size: 0.75rem;
        }
    }
    @media screen and (min-width: 1600px) and (min-height: 800px) {
        :root {
            font-size: 0.8rem;
        }
    }
    @media screen and (min-width: 1750px) and (min-height: 900px) {
        :root {
            font-size: 0.9rem;
        }
    }
    @media screen and (min-width: 1850px) and (min-height: 1000px) {
        :root {
            font-size: 1rem;
        }
    }
`,qn;(function(e){e.mouse="mouse",e.touch="touch",e.keyboard="keyboard"})(qn||(qn={}));class lO{get delay(){var t;return(t=this.args.delay)!==null&&t!==void 0?t:0}get scrollAngleRanges(){return this.args.scrollAngleRanges}get getDropTargetElementsAtPoint(){return this.args.getDropTargetElementsAtPoint}get ignoreContextMenu(){var t;return(t=this.args.ignoreContextMenu)!==null&&t!==void 0?t:!1}get enableHoverOutsideTarget(){var t;return(t=this.args.enableHoverOutsideTarget)!==null&&t!==void 0?t:!1}get enableKeyboardEvents(){var t;return(t=this.args.enableKeyboardEvents)!==null&&t!==void 0?t:!1}get enableMouseEvents(){var t;return(t=this.args.enableMouseEvents)!==null&&t!==void 0?t:!1}get enableTouchEvents(){var t;return(t=this.args.enableTouchEvents)!==null&&t!==void 0?t:!0}get touchSlop(){return this.args.touchSlop||0}get delayTouchStart(){var t,n,r,o;return(o=(r=(t=this.args)===null||t===void 0?void 0:t.delayTouchStart)!==null&&r!==void 0?r:(n=this.args)===null||n===void 0?void 0:n.delay)!==null&&o!==void 0?o:0}get delayMouseStart(){var t,n,r,o;return(o=(r=(t=this.args)===null||t===void 0?void 0:t.delayMouseStart)!==null&&r!==void 0?r:(n=this.args)===null||n===void 0?void 0:n.delay)!==null&&o!==void 0?o:0}get window(){if(this.context&&this.context.window)return this.context.window;if(typeof window!="undefined")return window}get document(){var t;if(!((t=this.context)===null||t===void 0)&&t.document)return this.context.document;if(this.window)return this.window.document}get rootElement(){var t;return((t=this.args)===null||t===void 0?void 0:t.rootElement)||this.document}constructor(t,n){this.args=t,this.context=n}}function cO(e,t,n,r){return Math.sqrt(Math.pow(Math.abs(n-e),2)+Math.pow(Math.abs(r-t),2))}function uO(e,t,n,r,o){if(!o)return!1;const i=Math.atan2(r-t,n-e)*180/Math.PI+180;for(let s=0;s<o.length;++s){const a=o[s];if(a&&(a.start==null||i>=a.start)&&(a.end==null||i<=a.end))return!0}return!1}const dO={Left:1,Right:2,Center:4},fO={Left:0,Center:1,Right:2};function Fc(e){return e.button===void 0||e.button===fO.Left}function hO(e){return e.buttons===void 0||(e.buttons&dO.Left)===0}function r2(e){return!!e.targetTouches}const pO=1;function mO(e){const t=e.nodeType===pO?e:e.parentElement;if(!t)return;const{top:n,left:r}=t.getBoundingClientRect();return{x:r,y:n}}function gO(e,t){if(e.targetTouches.length===1)return Ma(e.targetTouches[0]);if(t&&e.touches.length===1&&e.touches[0].target===t.target)return Ma(e.touches[0])}function Ma(e,t){return r2(e)?gO(e,t):{x:e.clientX,y:e.clientY}}const ng=(()=>{let e=!1;try{addEventListener("test",()=>{},Object.defineProperty({},"passive",{get(){return e=!0,!0}}))}catch{}return e})(),Xo={[qn.mouse]:{start:"mousedown",move:"mousemove",end:"mouseup",contextmenu:"contextmenu"},[qn.touch]:{start:"touchstart",move:"touchmove",end:"touchend"},[qn.keyboard]:{keydown:"keydown"}};class vi{profile(){var t;return{sourceNodes:this.sourceNodes.size,sourcePreviewNodes:this.sourcePreviewNodes.size,sourcePreviewNodeOptions:this.sourcePreviewNodeOptions.size,targetNodes:this.targetNodes.size,dragOverTargetIds:((t=this.dragOverTargetIds)===null||t===void 0?void 0:t.length)||0}}get document(){return this.options.document}setup(){const t=this.options.rootElement;!t||(ce(!vi.isSetUp,"Cannot have two Touch backends at the same time."),vi.isSetUp=!0,this.addEventListener(t,"start",this.getTopMoveStartHandler()),this.addEventListener(t,"start",this.handleTopMoveStartCapture,!0),this.addEventListener(t,"move",this.handleTopMove),this.addEventListener(t,"move",this.handleTopMoveCapture,!0),this.addEventListener(t,"end",this.handleTopMoveEndCapture,!0),this.options.enableMouseEvents&&!this.options.ignoreContextMenu&&this.addEventListener(t,"contextmenu",this.handleTopMoveEndCapture),this.options.enableKeyboardEvents&&this.addEventListener(t,"keydown",this.handleCancelOnEscape,!0))}teardown(){const t=this.options.rootElement;!t||(vi.isSetUp=!1,this._mouseClientOffset={},this.removeEventListener(t,"start",this.handleTopMoveStartCapture,!0),this.removeEventListener(t,"start",this.handleTopMoveStart),this.removeEventListener(t,"move",this.handleTopMoveCapture,!0),this.removeEventListener(t,"move",this.handleTopMove),this.removeEventListener(t,"end",this.handleTopMoveEndCapture,!0),this.options.enableMouseEvents&&!this.options.ignoreContextMenu&&this.removeEventListener(t,"contextmenu",this.handleTopMoveEndCapture),this.options.enableKeyboardEvents&&this.removeEventListener(t,"keydown",this.handleCancelOnEscape,!0),this.uninstallSourceNodeRemovalObserver())}addEventListener(t,n,r,o=!1){const i=ng?{capture:o,passive:!1}:o;this.listenerTypes.forEach(function(s){const a=Xo[s][n];a&&t.addEventListener(a,r,i)})}removeEventListener(t,n,r,o=!1){const i=ng?{capture:o,passive:!1}:o;this.listenerTypes.forEach(function(s){const a=Xo[s][n];a&&t.removeEventListener(a,r,i)})}connectDragSource(t,n){const r=this.handleMoveStart.bind(this,t);return this.sourceNodes.set(t,n),this.addEventListener(n,"start",r),()=>{this.sourceNodes.delete(t),this.removeEventListener(n,"start",r)}}connectDragPreview(t,n,r){return this.sourcePreviewNodeOptions.set(t,r),this.sourcePreviewNodes.set(t,n),()=>{this.sourcePreviewNodes.delete(t),this.sourcePreviewNodeOptions.delete(t)}}connectDropTarget(t,n){const r=this.options.rootElement;if(!this.document||!r)return()=>{};const o=i=>{if(!this.document||!r||!this.monitor.isDragging())return;let s;switch(i.type){case Xo.mouse.move:s={x:i.clientX,y:i.clientY};break;case Xo.touch.move:var a,l;s={x:((a=i.touches[0])===null||a===void 0?void 0:a.clientX)||0,y:((l=i.touches[0])===null||l===void 0?void 0:l.clientY)||0};break}const c=s!=null?this.document.elementFromPoint(s.x,s.y):void 0,u=c&&n.contains(c);if(c===n||u)return this.handleMove(i,t)};return this.addEventListener(this.document.body,"move",o),this.targetNodes.set(t,n),()=>{this.document&&(this.targetNodes.delete(t),this.removeEventListener(this.document.body,"move",o))}}getTopMoveStartHandler(){return!this.options.delayTouchStart&&!this.options.delayMouseStart?this.handleTopMoveStart:this.handleTopMoveStartDelay}installSourceNodeRemovalObserver(t){this.uninstallSourceNodeRemovalObserver(),this.draggedSourceNode=t,this.draggedSourceNodeRemovalObserver=new MutationObserver(()=>{t&&!t.parentElement&&(this.resurrectSourceNode(),this.uninstallSourceNodeRemovalObserver())}),!(!t||!t.parentElement)&&this.draggedSourceNodeRemovalObserver.observe(t.parentElement,{childList:!0})}resurrectSourceNode(){this.document&&this.draggedSourceNode&&(this.draggedSourceNode.style.display="none",this.draggedSourceNode.removeAttribute("data-reactid"),this.document.body.appendChild(this.draggedSourceNode))}uninstallSourceNodeRemovalObserver(){this.draggedSourceNodeRemovalObserver&&this.draggedSourceNodeRemovalObserver.disconnect(),this.draggedSourceNodeRemovalObserver=void 0,this.draggedSourceNode=void 0}constructor(t,n,r){this.getSourceClientOffset=o=>{const i=this.sourceNodes.get(o);return i&&mO(i)},this.handleTopMoveStartCapture=o=>{!Fc(o)||(this.moveStartSourceIds=[])},this.handleMoveStart=o=>{Array.isArray(this.moveStartSourceIds)&&this.moveStartSourceIds.unshift(o)},this.handleTopMoveStart=o=>{if(!Fc(o))return;const i=Ma(o);i&&(r2(o)&&(this.lastTargetTouchFallback=o.targetTouches[0]),this._mouseClientOffset=i),this.waitingForDelay=!1},this.handleTopMoveStartDelay=o=>{if(!Fc(o))return;const i=o.type===Xo.touch.start?this.options.delayTouchStart:this.options.delayMouseStart;this.timeout=setTimeout(this.handleTopMoveStart.bind(this,o),i),this.waitingForDelay=!0},this.handleTopMoveCapture=()=>{this.dragOverTargetIds=[]},this.handleMove=(o,i)=>{this.dragOverTargetIds&&this.dragOverTargetIds.unshift(i)},this.handleTopMove=o=>{if(this.timeout&&clearTimeout(this.timeout),!this.document||this.waitingForDelay)return;const{moveStartSourceIds:i,dragOverTargetIds:s}=this,a=this.options.enableHoverOutsideTarget,l=Ma(o,this.lastTargetTouchFallback);if(!l)return;if(this._isScrolling||!this.monitor.isDragging()&&uO(this._mouseClientOffset.x||0,this._mouseClientOffset.y||0,l.x,l.y,this.options.scrollAngleRanges)){this._isScrolling=!0;return}if(!this.monitor.isDragging()&&this._mouseClientOffset.hasOwnProperty("x")&&i&&cO(this._mouseClientOffset.x||0,this._mouseClientOffset.y||0,l.x,l.y)>(this.options.touchSlop?this.options.touchSlop:0)&&(this.moveStartSourceIds=void 0,this.actions.beginDrag(i,{clientOffset:this._mouseClientOffset,getSourceClientOffset:this.getSourceClientOffset,publishSource:!1})),!this.monitor.isDragging())return;const c=this.sourceNodes.get(this.monitor.getSourceId());this.installSourceNodeRemovalObserver(c),this.actions.publishDragSource(),o.cancelable&&o.preventDefault();const u=(s||[]).map(w=>this.targetNodes.get(w)).filter(w=>!!w),d=this.options.getDropTargetElementsAtPoint?this.options.getDropTargetElementsAtPoint(l.x,l.y,u):this.document.elementsFromPoint(l.x,l.y),p=[];for(const w in d){if(!d.hasOwnProperty(w))continue;let x=d[w];for(x!=null&&p.push(x);x;)x=x.parentElement,x&&p.indexOf(x)===-1&&p.push(x)}const y=p.filter(w=>u.indexOf(w)>-1).map(w=>this._getDropTargetId(w)).filter(w=>!!w).filter((w,x,b)=>b.indexOf(w)===x);if(a)for(const w in this.targetNodes){const x=this.targetNodes.get(w);if(c&&x&&x.contains(c)&&y.indexOf(w)===-1){y.unshift(w);break}}y.reverse(),this.actions.hover(y,{clientOffset:l})},this._getDropTargetId=o=>{const i=this.targetNodes.keys();let s=i.next();for(;s.done===!1;){const a=s.value;if(o===this.targetNodes.get(a))return a;s=i.next()}},this.handleTopMoveEndCapture=o=>{if(this._isScrolling=!1,this.lastTargetTouchFallback=void 0,!!hO(o)){if(!this.monitor.isDragging()||this.monitor.didDrop()){this.moveStartSourceIds=void 0;return}o.cancelable&&o.preventDefault(),this._mouseClientOffset={},this.uninstallSourceNodeRemovalObserver(),this.actions.drop(),this.actions.endDrag()}},this.handleCancelOnEscape=o=>{o.key==="Escape"&&this.monitor.isDragging()&&(this._mouseClientOffset={},this.uninstallSourceNodeRemovalObserver(),this.actions.endDrag())},this.options=new lO(r,n),this.actions=t.getActions(),this.monitor=t.getMonitor(),this.sourceNodes=new Map,this.sourcePreviewNodes=new Map,this.sourcePreviewNodeOptions=new Map,this.targetNodes=new Map,this.listenerTypes=[],this._mouseClientOffset={},this._isScrolling=!1,this.options.enableMouseEvents&&this.listenerTypes.push(qn.mouse),this.options.enableTouchEvents&&this.listenerTypes.push(qn.touch),this.options.enableKeyboardEvents&&this.listenerTypes.push(qn.keyboard)}}const yO=function(t,n={},r={}){return new vi(t,n,r)},rg=document.getElementById("root");rg&&zc.createRoot(rg).render(f(Ke.StrictMode,{children:f(Ib,{children:P(Ab,{children:[f(rO,{children:f(oO,{children:f(T4,{children:f(Y6,{children:f(k9,{children:f(pk,{children:P(s7,{backend:yO,options:{enableMouseEvents:!0},children:[f(fP,{}),f(sO,{})]})})})})})})}),f(aO,{})]})})}));
