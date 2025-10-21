Shader "Unlit/04_texture"
{
    Properties
    {
        //_Color("Color", Color) = (1,0,0,1)
        _MainTex ("Texture", 2D) = "white" {}
    }




    SubShader {
        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            fixed4 _Color;

            struct appdata {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float3 worldPosition : TEXCOORD1;
                float2 uv : TEXCOORD0;

            };

            struct v2f {
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                float3 worldPosition : TEXCOORD1;
                float2 uv : TEXCOORD0;

            };

            v2f vert(appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.worldPosition = mul(unity_ObjectToWorld, v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 ambient = _Color * 0.3 * _LightColor0;
                // return ambient;
                fixed4 tex = tex2D(_MainTex, i.uv);

                float intensity = 
                    saturate(dot(normalize(i.normal), _WorldSpaceLightPos0));
                fixed4 color = fixed4(1,0,0,1);
                fixed4 diffuse = color * intensity * _LightColor0;
                //return diffuse;

                float3 eyeDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPosition);
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                i.normal = normalize(i.normal);
                float3 reflectDir = -lightDir + 2 * i.normal * dot(i.normal, lightDir);
                fixed4 specular = pow(saturate(dot(reflectDir, eyeDir)), 20) * _LightColor0;
                // return specular;

                //fixed4 phong = ambient + diffuse + specular;
                fixed4 phong = tex + diffuse + specular;
                return phong;
            }
            ENDCG
        }
    }
}
