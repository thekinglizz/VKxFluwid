export const origin = "http://localhost:5000";

const extraVkPlatform = [
    'web',
    'mobileWeb',
    'miniappWeb',
    'miniappMobile',
    'okMiniappWeb',
    'okMiniappMobile',
];

export function getUrl() {
    // params
    let testParams = {
        // Widget params
        id: 1333,
        actionEventId: 7408,
        cityId: 3,
        zone: "test",
        // VK params
        extra_vkplatform: extraVkPlatform[0],
        interaction_id: 1234,
        extra_session_id: 1234,
        extra_unixtime_click: Date.now(),
        extra_platform: 1234,
        // VK UTM params
        utm_source: '1234',
        utm_campaign: '1234',
        utm_medium: '1234',
        utm_term: '1234',
        utm_content: '1234',
    };

    // create query params
    const params = Object.entries(testParams)
        .map(([key, value]) => `${encodeURIComponent(key)}=${encodeURIComponent(value)}`)
        .join('&');

    // build link
    let result = params ? `${origin}\?${params}` : `${origin}`;
    console.log(result);
    return result;
}
