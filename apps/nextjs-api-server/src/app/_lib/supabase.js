import { createBrowserClient } from "@supabase/ssr";

const supabase = createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY,
)

const user_table = 'users_v3';
const transaction_table = 'transactions_v3';

export const signIn = async (email, password) => {
    const { data: {
        user
    }, error } = await supabase.auth.signInWithPassword({
        email,
        password,
    });
    if (error) throw error;
    return user;
}

export const logout = async () => {
    await supabase.auth.signOut();
}

export const getCurrentUser = () => {
    return supabase.auth.getUser();
}

export const getUserData = async () => {
    const { data: { user } } = await getCurrentUser();
    const { data, error } = await supabase
        .from(user_table)
        .select('*')
        .eq('id', user.id).single();
    if (error) throw error;
    return data;
}

export const getTransactions = async () => {
    const { data: { user } } = await getCurrentUser();
    const { data: userData, } = await supabase
        .from(user_table)
        .select('*')
        .eq('id', user.id).single();

    const { data, error } = await supabase
        .from(transaction_table)
        .select('*, receiver:receiver_id(*)')
        .eq("receiver.country", userData.country)
        .eq('status', "completed")
        .not('receiver', 'is', null)
        .order('created_at', { ascending: false });
    if (error) throw error;
    return data;
}

export const getStats = async () => {
    const { data: { user } } = await getCurrentUser();
    const { data: userData, } = await supabase
        .from(user_table)
        .select('*')
        .eq('id', user.id).single();
    const { data, error } = await supabase
        .rpc('sum_amounts_by_status_for_country_v3', {country_filter: userData.country}).single();
    if (error) throw error;
    return data;
}

export const burnToken = async (id) => {
    const { error } = await supabase
        .from(transaction_table)
        .update({ status: "burned" })
        .eq('id', id);
    if (error) throw error;
    return true;
}



