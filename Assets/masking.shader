Shader "Unlit/worldspaceTex"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Pattern ("Pattern", 2D) = "black" {}
        _Rock ("Rock", 2D) = "black" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
      
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
         
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _Pattern;
            sampler2D _Rock;

            v2f vert (appdata v)
            {
                v2f o;
                o.worldPos = mul(UNITY_MATRIX_M, float4(v.vertex.xyz, 1));
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float GetWave(float coord)
            {
                float wave = cos((coord - _Time.y * 0.1) * 6.28 * 5) * 0.5 + 0.5;
                wave *= coord;
                return wave;
            } 

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                float4 moss = tex2D(_MainTex, i.uv);
                float mask = tex2D(_Pattern, i.uv).r;
                float4 rock = tex2D(_Rock, i.uv);
                
                return float4(lerp(moss, rock, mask));
                //fixed4 col = tex2D(_MainTex, i.uv);
                //
                //return col;
            }
            ENDCG
        }
    }
}
