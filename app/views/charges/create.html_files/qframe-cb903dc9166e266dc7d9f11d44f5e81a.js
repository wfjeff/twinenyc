(function(){function e(){return"xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g,function(e){var t=Math.random()*16|0,n=e==="x"?t:t&3|8;return n.toString(16)})}function t(e){var t,n,r,i,s,o;t=document.cookie.split("; ");for(o=0;o<t.length;o++){n=t[o],r=n.indexOf("="),i=decodeURIComponent(n.substr(0,r)),s=decodeURIComponent(n.substr(r+1));if(i===e)return s}return null}function n(e,t,n){var r,i;n==null&&(n={}),n.expires===!0&&(n.expires=-1),typeof n.expires=="number"&&(r=new Date,r.setTime(r.getTime()+n.expires*24*60*60*1e3),n.expires=r),n.path==null&&(n.path="/"),t=(t+"").replace(/[^!#-+\--:<-\[\]-~]/g,encodeURIComponent),i=encodeURIComponent(e)+"="+t,n.expires&&(i+=";expires="+n.expires.toGMTString()),n.path&&(i+=";path="+n.path),n.domain&&(i+=";domain="+n.domain),document.cookie=i}function r(){var r;return window.navigator.doNotTrack?"DNT":(r=t("cid")||e(),n("cid",r,{expires:7200,domain:".stripe.com"}),r)}function i(){var t;if(window.navigator.doNotTrack)return"DNT";try{return t=localStorage.getItem("lsid"),t==null&&(t=e(),localStorage.setItem("lsid",t)),t}catch(n){return"NA"}}function s(e){var t,n,r;r="";for(t in e)n=e[t],typeof n=="object"&&(n=JSON.stringify(n)),r+="&"+encodeURIComponent(t)+"="+encodeURIComponent(n);return r.replace("&","?")}window.stripeEvent=function(t,n){n==null&&(n={}),n.event=t,n.cid=r(),n.lsid=i(),(new Image).src="https://q.stripe.com"+s(n)},window.makeTrackingRequest=function(t){t==null&&(t={}),t.href=window.location.href,t.referrer=document.referrer,stripeEvent("pageView",{sc:s(t)})}}).call(this);