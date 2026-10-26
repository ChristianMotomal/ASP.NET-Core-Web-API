using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;

namespace api.Extensions
{
    public static class ClaimsExtensions
    {
        public static string GetUsername(this ClaimsPrincipal user)
        {
            return user.FindFirstValue(JwtRegisteredClaimNames.GivenName)
                ?? user.FindFirstValue(ClaimTypes.GivenName)
                ?? throw new InvalidOperationException("Username claim is missing from the token.");
        }
    }
}